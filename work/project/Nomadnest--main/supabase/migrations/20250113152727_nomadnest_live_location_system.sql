-- Location: supabase/migrations/20250113152727_nomadnest_live_location_system.sql
-- Schema Analysis: Basic auth system exists with user_profiles table
-- Integration Type: NEW_MODULE - Live location sharing for hangouts
-- Dependencies: References existing user_profiles table

-- 1. Create custom types first
CREATE TYPE public.hangout_status AS ENUM ('draft', 'active', 'completed', 'cancelled');
CREATE TYPE public.location_accuracy_level AS ENUM ('exact', 'approximate', 'area_only');
CREATE TYPE public.hangout_member_status AS ENUM ('invited', 'joined', 'declined', 'left');

-- 2. Create hangouts table
CREATE TABLE public.hangouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    host_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    venue_name TEXT,
    venue_address TEXT,
    venue_place_id TEXT,
    venue_latitude DECIMAL(10, 8),
    venue_longitude DECIMAL(11, 8),
    status public.hangout_status DEFAULT 'draft'::public.hangout_status,
    starts_at TIMESTAMPTZ,
    ends_at TIMESTAMPTZ,
    max_participants INTEGER DEFAULT 10,
    is_location_sharing_enabled BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create hangout members junction table
CREATE TABLE public.hangout_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hangout_id UUID REFERENCES public.hangouts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    status public.hangout_member_status DEFAULT 'invited'::public.hangout_member_status,
    joined_at TIMESTAMPTZ,
    left_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(hangout_id, user_id)
);

-- 4. Create live location sharing table
CREATE TABLE public.live_location_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hangout_id UUID REFERENCES public.hangouts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    is_sharing BOOLEAN DEFAULT false,
    accuracy_level public.location_accuracy_level DEFAULT 'exact'::public.location_accuracy_level,
    current_latitude DECIMAL(10, 8),
    current_longitude DECIMAL(11, 8),
    heading DECIMAL(5, 2),
    speed DECIMAL(6, 2),
    battery_level INTEGER,
    last_update TIMESTAMPTZ,
    session_started_at TIMESTAMPTZ,
    session_ended_at TIMESTAMPTZ,
    update_frequency INTEGER DEFAULT 10,
    visibility_scope TEXT DEFAULT 'all',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(hangout_id, user_id)
);

-- 5. Create location sharing history for analytics
CREATE TABLE public.location_sharing_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hangout_id UUID REFERENCES public.hangouts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    accuracy DECIMAL(6, 2),
    heading DECIMAL(5, 2),
    speed DECIMAL(6, 2),
    recorded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Create essential indexes
CREATE INDEX idx_hangouts_host_id ON public.hangouts(host_id);
CREATE INDEX idx_hangouts_status ON public.hangouts(status);
CREATE INDEX idx_hangouts_starts_at ON public.hangouts(starts_at);
CREATE INDEX idx_hangout_members_hangout_id ON public.hangout_members(hangout_id);
CREATE INDEX idx_hangout_members_user_id ON public.hangout_members(user_id);
CREATE INDEX idx_live_location_sessions_hangout_id ON public.live_location_sessions(hangout_id);
CREATE INDEX idx_live_location_sessions_user_id ON public.live_location_sessions(user_id);
CREATE INDEX idx_live_location_sessions_is_sharing ON public.live_location_sessions(is_sharing);
CREATE INDEX idx_location_history_hangout_user ON public.location_sharing_history(hangout_id, user_id);
CREATE INDEX idx_location_history_recorded_at ON public.location_sharing_history(recorded_at);

-- 7. Enable RLS for all tables
ALTER TABLE public.hangouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hangout_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_location_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.location_sharing_history ENABLE ROW LEVEL SECURITY;

-- 8. Create helper functions (MUST BE BEFORE RLS POLICIES)
CREATE OR REPLACE FUNCTION public.is_hangout_member(hangout_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.hangout_members hm
    WHERE hm.hangout_id = hangout_uuid 
    AND hm.user_id = auth.uid()
    AND hm.status IN ('joined', 'invited')
)
$$;

CREATE OR REPLACE FUNCTION public.can_view_hangout_location(hangout_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.hangouts h
    JOIN public.hangout_members hm ON h.id = hm.hangout_id
    WHERE h.id = hangout_uuid 
    AND hm.user_id = auth.uid()
    AND h.is_location_sharing_enabled = true
    AND hm.status = 'joined'
)
$$;

-- 9. Create RLS policies using correct patterns

-- Pattern 2: Simple user ownership for hangouts
CREATE POLICY "users_manage_own_hangouts"
ON public.hangouts
FOR ALL
TO authenticated
USING (host_id = auth.uid())
WITH CHECK (host_id = auth.uid());

-- Pattern 4: Public read for active hangouts, private write
CREATE POLICY "public_can_view_active_hangouts"
ON public.hangouts
FOR SELECT
TO authenticated
USING (status = 'active'::public.hangout_status OR public.is_hangout_member(id));

-- Pattern 7: Complex relationships for hangout members
CREATE POLICY "members_can_manage_hangout_memberships"
ON public.hangout_members
FOR ALL
TO authenticated
USING (user_id = auth.uid() OR public.is_hangout_member(hangout_id))
WITH CHECK (user_id = auth.uid());

-- Pattern 2: Simple user ownership for location sessions
CREATE POLICY "users_manage_own_location_sessions"
ON public.live_location_sessions
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Pattern 7: Members can view location sessions
CREATE POLICY "members_can_view_location_sessions"
ON public.live_location_sessions
FOR SELECT
TO authenticated
USING (public.can_view_hangout_location(hangout_id));

-- Pattern 2: Simple user ownership for location history
CREATE POLICY "users_manage_own_location_history"
ON public.location_sharing_history
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Pattern 7: Members can view location history
CREATE POLICY "members_can_view_location_history"
ON public.location_sharing_history
FOR SELECT
TO authenticated
USING (public.can_view_hangout_location(hangout_id));

-- 10. Create trigger for updated_at timestamps
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER hangouts_updated_at
    BEFORE UPDATE ON public.hangouts
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER location_sessions_updated_at
    BEFORE UPDATE ON public.live_location_sessions
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- 11. Mock data for testing
DO $$
DECLARE
    host_user_id UUID;
    member_user_id UUID;
    hangout1_id UUID := gen_random_uuid();
    hangout2_id UUID := gen_random_uuid();
BEGIN
    -- Get existing users from user_profiles
    SELECT id INTO host_user_id FROM public.user_profiles WHERE email = 'test@nomadnest.com' LIMIT 1;
    SELECT id INTO member_user_id FROM public.user_profiles WHERE email = 'nomad@nomadnest.com' LIMIT 1;
    
    -- Create sample hangouts
    INSERT INTO public.hangouts (id, title, description, host_id, venue_name, venue_address, venue_latitude, venue_longitude, status, starts_at, is_location_sharing_enabled)
    VALUES 
        (hangout1_id, 'Digital Nomad Coffee Meetup', 'Casual coffee meetup for remote workers in Lisbon', host_user_id, 'The Coffee Spot', 'Rua do Carmo 23, Lisboa', 38.7071, -9.1359, 'active'::public.hangout_status, NOW() + INTERVAL '2 hours', true),
        (hangout2_id, 'Weekend Hiking Adventure', 'Explore the beautiful trails around Sintra', member_user_id, 'Sintra National Park', 'Sintra, Portugal', 38.7969, -9.3365, 'active'::public.hangout_status, NOW() + INTERVAL '1 day', true);
    
    -- Add members to hangouts
    INSERT INTO public.hangout_members (hangout_id, user_id, status, joined_at)
    VALUES 
        (hangout1_id, host_user_id, 'joined'::public.hangout_member_status, NOW()),
        (hangout1_id, member_user_id, 'joined'::public.hangout_member_status, NOW()),
        (hangout2_id, member_user_id, 'joined'::public.hangout_member_status, NOW()),
        (hangout2_id, host_user_id, 'joined'::public.hangout_member_status, NOW());
    
    -- Create active location sharing sessions
    INSERT INTO public.live_location_sessions (hangout_id, user_id, is_sharing, current_latitude, current_longitude, last_update, session_started_at, update_frequency)
    VALUES 
        (hangout1_id, host_user_id, true, 38.7071, -9.1359, NOW(), NOW(), 10),
        (hangout1_id, member_user_id, true, 38.7081, -9.1369, NOW(), NOW(), 10);
    
    -- Add some location history
    INSERT INTO public.location_sharing_history (hangout_id, user_id, latitude, longitude, accuracy, recorded_at)
    VALUES 
        (hangout1_id, host_user_id, 38.7070, -9.1358, 5.0, NOW() - INTERVAL '5 minutes'),
        (hangout1_id, host_user_id, 38.7071, -9.1359, 3.0, NOW() - INTERVAL '2 minutes'),
        (hangout1_id, member_user_id, 38.7080, -9.1368, 4.0, NOW() - INTERVAL '3 minutes');

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Mock data creation failed: %', SQLERRM;
END $$;

-- 12. Cleanup function for testing
CREATE OR REPLACE FUNCTION public.cleanup_location_test_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    DELETE FROM public.location_sharing_history WHERE hangout_id IN (SELECT id FROM public.hangouts WHERE title LIKE '%Test%' OR title LIKE '%Digital Nomad%');
    DELETE FROM public.live_location_sessions WHERE hangout_id IN (SELECT id FROM public.hangouts WHERE title LIKE '%Test%' OR title LIKE '%Digital Nomad%');
    DELETE FROM public.hangout_members WHERE hangout_id IN (SELECT id FROM public.hangouts WHERE title LIKE '%Test%' OR title LIKE '%Digital Nomad%');
    DELETE FROM public.hangouts WHERE title LIKE '%Test%' OR title LIKE '%Digital Nomad%';
    
    RAISE NOTICE 'Location sharing test data cleaned up successfully';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END $$;