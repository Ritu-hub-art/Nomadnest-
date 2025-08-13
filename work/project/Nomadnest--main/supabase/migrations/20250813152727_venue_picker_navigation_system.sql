-- Location: supabase/migrations/20250813152727_venue_picker_navigation_system.sql
-- Schema Analysis: Existing user_profiles table with basic user management
-- Integration Type: New Module - Venue Picker & Navigation System
-- Dependencies: user_profiles (existing table)

-- 1. Types and Enums
CREATE TYPE public.hangout_status AS ENUM ('draft', 'active', 'completed', 'cancelled');
CREATE TYPE public.location_sharing_status AS ENUM ('off', 'approximate', 'precise');
CREATE TYPE public.venue_type AS ENUM ('restaurant', 'cafe', 'park', 'museum', 'bar', 'attraction', 'outdoor', 'other');
CREATE TYPE public.navigation_mode AS ENUM ('walking', 'driving', 'transit', 'cycling');

-- 2. Core Tables
CREATE TABLE public.hangouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    status public.hangout_status DEFAULT 'draft'::public.hangout_status,
    max_participants INTEGER DEFAULT 10,
    scheduled_for TIMESTAMPTZ,
    venue_id UUID NULL,
    venue_name TEXT,
    venue_address TEXT,
    venue_place_id TEXT,
    venue_latitude DOUBLE PRECISION,
    venue_longitude DOUBLE PRECISION,
    venue_type public.venue_type DEFAULT 'other'::public.venue_type,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.hangout_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hangout_id UUID REFERENCES public.hangouts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    location_sharing_status public.location_sharing_status DEFAULT 'off'::public.location_sharing_status,
    is_host BOOLEAN DEFAULT false,
    UNIQUE(hangout_id, user_id)
);

CREATE TABLE public.live_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hangout_id UUID REFERENCES public.hangouts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    accuracy DOUBLE PRECISION,
    heading DOUBLE PRECISION,
    speed DOUBLE PRECISION,
    is_approximate BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP + INTERVAL '2 hours')
);

CREATE TABLE public.venue_search_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    venue_name TEXT NOT NULL,
    venue_place_id TEXT,
    venue_address TEXT,
    venue_latitude DOUBLE PRECISION,
    venue_longitude DOUBLE PRECISION,
    venue_type public.venue_type DEFAULT 'other'::public.venue_type,
    search_count INTEGER DEFAULT 1,
    last_searched_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.navigation_routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hangout_id UUID REFERENCES public.hangouts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    origin_latitude DOUBLE PRECISION NOT NULL,
    origin_longitude DOUBLE PRECISION NOT NULL,
    destination_latitude DOUBLE PRECISION NOT NULL,
    destination_longitude DOUBLE PRECISION NOT NULL,
    navigation_mode public.navigation_mode DEFAULT 'walking'::public.navigation_mode,
    distance_meters INTEGER,
    duration_seconds INTEGER,
    polyline_encoded TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Indexes for Performance
CREATE INDEX idx_hangouts_host_id ON public.hangouts(host_id);
CREATE INDEX idx_hangouts_status ON public.hangouts(status);
CREATE INDEX idx_hangouts_scheduled_for ON public.hangouts(scheduled_for);
CREATE INDEX idx_hangouts_venue_location ON public.hangouts(venue_latitude, venue_longitude);

CREATE INDEX idx_hangout_participants_hangout_id ON public.hangout_participants(hangout_id);
CREATE INDEX idx_hangout_participants_user_id ON public.hangout_participants(user_id);
CREATE INDEX idx_hangout_participants_sharing_status ON public.hangout_participants(location_sharing_status);

CREATE INDEX idx_live_locations_hangout_id ON public.live_locations(hangout_id);
CREATE INDEX idx_live_locations_user_id ON public.live_locations(user_id);
CREATE INDEX idx_live_locations_expires_at ON public.live_locations(expires_at);
CREATE INDEX idx_live_locations_created_at ON public.live_locations(created_at);

CREATE INDEX idx_venue_search_history_user_id ON public.venue_search_history(user_id);
CREATE INDEX idx_venue_search_history_last_searched ON public.venue_search_history(last_searched_at);

CREATE INDEX idx_navigation_routes_hangout_id ON public.navigation_routes(hangout_id);
CREATE INDEX idx_navigation_routes_user_id ON public.navigation_routes(user_id);

-- 4. Row Level Security Setup
ALTER TABLE public.hangouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hangout_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.venue_search_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.navigation_routes ENABLE ROW LEVEL SECURITY;

-- 5. Helper Functions (Created Before RLS Policies)
CREATE OR REPLACE FUNCTION public.is_hangout_participant(hangout_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.hangout_participants hp
    WHERE hp.hangout_id = hangout_uuid 
    AND hp.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.is_hangout_host(hangout_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.hangouts h
    WHERE h.id = hangout_uuid 
    AND h.host_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.cleanup_expired_locations()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    DELETE FROM public.live_locations
    WHERE expires_at < CURRENT_TIMESTAMP;
END;
$$;

-- 6. RLS Policies Using Correct Patterns
CREATE POLICY "users_manage_own_hangouts"
ON public.hangouts
FOR ALL
TO authenticated
USING (host_id = auth.uid())
WITH CHECK (host_id = auth.uid());

CREATE POLICY "participants_can_view_hangouts"
ON public.hangouts
FOR SELECT
TO authenticated
USING (public.is_hangout_participant(id) OR host_id = auth.uid());

CREATE POLICY "users_manage_own_participation"
ON public.hangout_participants
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "participants_can_view_other_participants"
ON public.hangout_participants
FOR SELECT
TO authenticated
USING (public.is_hangout_participant(hangout_id));

CREATE POLICY "users_manage_own_live_locations"
ON public.live_locations
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "participants_can_view_live_locations"
ON public.live_locations
FOR SELECT
TO authenticated
USING (public.is_hangout_participant(hangout_id));

CREATE POLICY "users_manage_own_venue_search_history"
ON public.venue_search_history
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_navigation_routes"
ON public.navigation_routes
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- 7. Triggers for Data Management
CREATE OR REPLACE FUNCTION public.update_hangout_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER update_hangouts_timestamp
    BEFORE UPDATE ON public.hangouts
    FOR EACH ROW
    EXECUTE FUNCTION public.update_hangout_timestamp();

CREATE TRIGGER update_navigation_routes_timestamp
    BEFORE UPDATE ON public.navigation_routes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_hangout_timestamp();

-- 8. Mock Data for Development
DO $$
DECLARE
    existing_user_id UUID;
    hangout1_id UUID := gen_random_uuid();
    hangout2_id UUID := gen_random_uuid();
    venue_history1_id UUID := gen_random_uuid();
    venue_history2_id UUID := gen_random_uuid();
BEGIN
    -- Get existing user ID from user_profiles
    SELECT id INTO existing_user_id FROM public.user_profiles LIMIT 1;
    
    IF existing_user_id IS NOT NULL THEN
        -- Create sample hangouts
        INSERT INTO public.hangouts (id, host_id, title, description, status, venue_name, venue_address, venue_latitude, venue_longitude, venue_type, scheduled_for)
        VALUES
            (hangout1_id, existing_user_id, 'Coffee & Code Meetup', 'Casual meetup for digital nomads to work together', 'active'::public.hangout_status, 'Starbucks Downtown', '123 Main St, City Center', 40.7128, -74.0060, 'cafe'::public.venue_type, CURRENT_TIMESTAMP + INTERVAL '2 hours'),
            (hangout2_id, existing_user_id, 'Sunset Photography Walk', 'Explore the city and capture amazing sunset shots', 'draft'::public.hangout_status, 'Central Park', 'Central Park, New York', 40.7829, -73.9654, 'park'::public.venue_type, CURRENT_TIMESTAMP + INTERVAL '1 day');

        -- Add host as participant
        INSERT INTO public.hangout_participants (hangout_id, user_id, is_host, location_sharing_status)
        VALUES
            (hangout1_id, existing_user_id, true, 'precise'::public.location_sharing_status),
            (hangout2_id, existing_user_id, true, 'off'::public.location_sharing_status);

        -- Create venue search history
        INSERT INTO public.venue_search_history (id, user_id, venue_name, venue_address, venue_latitude, venue_longitude, venue_type, search_count)
        VALUES
            (venue_history1_id, existing_user_id, 'Blue Bottle Coffee', '456 Coffee Ave, Downtown', 40.7580, -73.9855, 'cafe'::public.venue_type, 3),
            (venue_history2_id, existing_user_id, 'Brooklyn Bridge Park', 'Brooklyn Bridge Park, Brooklyn', 40.7024, -73.9969, 'park'::public.venue_type, 1);

        -- Create sample live location (for active hangout)
        INSERT INTO public.live_locations (hangout_id, user_id, latitude, longitude, accuracy, heading, speed)
        VALUES (hangout1_id, existing_user_id, 40.7128, -74.0060, 5.0, 45.0, 0.0);

        -- Create sample navigation route
        INSERT INTO public.navigation_routes (hangout_id, user_id, origin_latitude, origin_longitude, destination_latitude, destination_longitude, navigation_mode, distance_meters, duration_seconds)
        VALUES (hangout1_id, existing_user_id, 40.7589, -73.9851, 40.7128, -74.0060, 'walking'::public.navigation_mode, 1200, 900);

    ELSE
        RAISE NOTICE 'No existing users found. Please create users first.';
    END IF;
END $$;