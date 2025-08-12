-- Location: supabase/migrations/20250112144558_nomadnest_auth_system.sql
-- Schema Analysis: Fresh project - no existing tables
-- Integration Type: Complete authentication system
-- Dependencies: auth.users (Supabase managed)

-- 1. Create custom types
CREATE TYPE public.user_role AS ENUM ('admin', 'nomad', 'host', 'member');
CREATE TYPE public.verification_status AS ENUM ('pending', 'verified', 'rejected');
CREATE TYPE public.account_status AS ENUM ('active', 'inactive', 'suspended');

-- 2. Core user profiles table (intermediary for auth.users)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    display_name TEXT,
    bio TEXT,
    profile_image_url TEXT,
    role public.user_role DEFAULT 'nomad'::public.user_role,
    verification_status public.verification_status DEFAULT 'pending'::public.verification_status,
    account_status public.account_status DEFAULT 'active'::public.account_status,
    city TEXT,
    country TEXT,
    languages TEXT[],
    is_active BOOLEAN DEFAULT true,
    email_verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Email verification codes table
CREATE TABLE public.email_verification_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    verification_code TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '10 minutes'),
    is_used BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Essential indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_user_profiles_status ON public.user_profiles(account_status);
CREATE INDEX idx_email_verification_codes_user_id ON public.email_verification_codes(user_id);
CREATE INDEX idx_email_verification_codes_code ON public.email_verification_codes(verification_code);
CREATE INDEX idx_email_verification_codes_expires ON public.email_verification_codes(expires_at);

-- 5. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_verification_codes ENABLE ROW LEVEL SECURITY;

-- 6. RLS Policies - Pattern 1: Core user table (user_profiles)
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Public read access for user profiles (for displaying nomad profiles publicly)
CREATE POLICY "public_can_view_active_user_profiles"
ON public.user_profiles
FOR SELECT
TO public
USING (account_status = 'active'::public.account_status AND is_active = true);

-- Pattern 2: Simple user ownership for verification codes
CREATE POLICY "users_manage_own_verification_codes"
ON public.email_verification_codes
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- 7. Functions for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (
        id, 
        email, 
        full_name, 
        display_name,
        role
    )
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'role', 'nomad')::public.user_role
    );
    RETURN NEW;
END;
$$;

-- 8. Function to generate verification codes
CREATE OR REPLACE FUNCTION public.generate_verification_code()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
$$;

-- 9. Function to create verification code
CREATE OR REPLACE FUNCTION public.create_verification_code(
    user_email TEXT,
    user_uuid UUID DEFAULT NULL
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    verification_code TEXT;
    target_user_id UUID;
BEGIN
    -- Generate 6-digit code
    verification_code := public.generate_verification_code();
    
    -- Use provided user_id or current auth user
    target_user_id := COALESCE(user_uuid, auth.uid());
    
    -- Invalidate old codes
    UPDATE public.email_verification_codes 
    SET is_used = true 
    WHERE user_id = target_user_id AND email = user_email AND is_used = false;
    
    -- Insert new verification code
    INSERT INTO public.email_verification_codes (
        user_id, 
        email, 
        verification_code
    )
    VALUES (target_user_id, user_email, verification_code);
    
    RETURN verification_code;
END;
$$;

-- 10. Function to verify email code
CREATE OR REPLACE FUNCTION public.verify_email_code(
    user_email TEXT,
    input_code TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    is_valid BOOLEAN := false;
    target_user_id UUID;
BEGIN
    -- Check if code is valid and not expired
    SELECT user_id INTO target_user_id
    FROM public.email_verification_codes
    WHERE email = user_email 
      AND verification_code = input_code 
      AND is_used = false 
      AND expires_at > CURRENT_TIMESTAMP
    LIMIT 1;
    
    IF target_user_id IS NOT NULL THEN
        -- Mark code as used
        UPDATE public.email_verification_codes 
        SET is_used = true 
        WHERE user_id = target_user_id 
          AND email = user_email 
          AND verification_code = input_code;
        
        -- Update user profile verification status
        UPDATE public.user_profiles 
        SET 
            email_verified_at = CURRENT_TIMESTAMP,
            verification_status = 'verified'::public.verification_status,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = target_user_id;
        
        is_valid := true;
    END IF;
    
    RETURN is_valid;
END;
$$;

-- 11. Trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 12. Mock data for testing
DO $$
DECLARE
    test_user_uuid UUID := gen_random_uuid();
    nomad_user_uuid UUID := gen_random_uuid();
    host_user_uuid UUID := gen_random_uuid();
BEGIN
    -- Create test auth users with all required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (test_user_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'test@nomadnest.com', crypt('TestPass123!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Test User", "display_name": "TestUser", "role": "nomad"}'::jsonb, 
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (nomad_user_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'nomad@nomadnest.com', crypt('NomadPass123!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Digital Nomad", "display_name": "DigitalNomad", "role": "nomad"}'::jsonb,
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (host_user_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'host@nomadnest.com', crypt('HostPass123!', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Travel Host", "display_name": "TravelHost", "role": "host"}'::jsonb,
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Update user profiles with additional data
    UPDATE public.user_profiles 
    SET 
        bio = 'Passionate digital nomad exploring the world',
        city = 'Lisbon',
        country = 'Portugal',
        languages = ARRAY['English', 'Spanish', 'Portuguese'],
        verification_status = 'verified'::public.verification_status,
        email_verified_at = CURRENT_TIMESTAMP
    WHERE id = nomad_user_uuid;

    UPDATE public.user_profiles 
    SET 
        bio = 'Experienced traveler offering amazing accommodations',
        city = 'Bali',
        country = 'Indonesia',
        languages = ARRAY['English', 'Indonesian'],
        role = 'host'::public.user_role,
        verification_status = 'verified'::public.verification_status,
        email_verified_at = CURRENT_TIMESTAMP
    WHERE id = host_user_uuid;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error in mock data: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error in mock data: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error in mock data: %', SQLERRM;
END $$;

-- 13. Cleanup function for testing
CREATE OR REPLACE FUNCTION public.cleanup_test_auth_data()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    auth_user_ids_to_delete UUID[];
BEGIN
    -- Get test user IDs
    SELECT ARRAY_AGG(id) INTO auth_user_ids_to_delete
    FROM auth.users
    WHERE email LIKE '%@nomadnest.com';

    -- Delete in dependency order
    DELETE FROM public.email_verification_codes WHERE user_id = ANY(auth_user_ids_to_delete);
    DELETE FROM public.user_profiles WHERE id = ANY(auth_user_ids_to_delete);
    DELETE FROM auth.users WHERE id = ANY(auth_user_ids_to_delete);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint prevents deletion: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Cleanup failed: %', SQLERRM;
END;
$$;