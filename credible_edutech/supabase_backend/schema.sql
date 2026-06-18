-- ============================================================================
-- CredibleEdutech Supabase Setup Script
-- RLS-enabled tables with device-based anti-piracy
-- ============================================================================

-- Enable RLS on public schema
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;

-- ============================================================================
-- TABLE: profiles
-- User profiles with device binding for anti-piracy
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  tier TEXT DEFAULT 'free' CHECK (tier IN ('free', 'premium')),
  device_id TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ============================================================================
-- TABLE: courses
-- Course metadata and descriptions
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  instructor TEXT,
  thumbnail_url TEXT,
  category TEXT DEFAULT 'quantitative',
  tier TEXT DEFAULT 'free' CHECK (tier IN ('free', 'premium')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Courses are viewable by everyone" ON public.courses
  FOR SELECT USING (true);

-- ============================================================================
-- TABLE: videos
-- Video metadata with Google Drive integration
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  google_drive_file_id TEXT NOT NULL,
  sequence INTEGER NOT NULL,
  duration INTEGER DEFAULT 0,
  thumbnail_url TEXT,
  lecture_notes TEXT,
  tier TEXT DEFAULT 'free' CHECK (tier IN ('free', 'premium')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Videos are viewable by everyone" ON public.videos
  FOR SELECT USING (true);

-- ============================================================================
-- TABLE: user_progress
-- Tracks user progress through courses
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES public.videos(id) ON DELETE CASCADE,
  current_position_seconds INTEGER DEFAULT 0,
  total_watched_seconds INTEGER DEFAULT 0,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, video_id)
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own progress" ON public.user_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress" ON public.user_progress
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own progress" ON public.user_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- TABLE: device_sessions
-- Track active device sessions (anti-piracy)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.device_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  device_id TEXT NOT NULL,
  session_token TEXT NOT NULL,
  last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, device_id)
);

ALTER TABLE public.device_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own sessions" ON public.device_sessions
  FOR SELECT USING (auth.uid() = user_id);

-- ============================================================================
-- FUNCTION: verify_device_binding()
-- Anti-piracy logic: Ensures JWT auth_uid matches stored device_id
-- ============================================================================
CREATE OR REPLACE FUNCTION public.verify_device_binding(
  p_user_id UUID,
  p_device_id TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_stored_device_id TEXT;
BEGIN
  SELECT device_id INTO v_stored_device_id
  FROM public.profiles
  WHERE id = p_user_id;

  -- If no profile found, deny access
  IF v_stored_device_id IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Compare provided device_id with stored device_id
  RETURN (v_stored_device_id = p_device_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- FUNCTION: check_device_access()
-- Trigger function to verify device binding on session creation
-- ============================================================================
CREATE OR REPLACE FUNCTION public.check_device_access()
RETURNS TRIGGER AS $$
BEGIN
  -- Verify device binding before allowing any operation
  IF NOT public.verify_device_binding(NEW.user_id, NEW.device_id) THEN
    RAISE EXCEPTION 'Device binding verification failed. Unauthorized access attempt.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for device session validation
CREATE TRIGGER enforce_device_binding
BEFORE INSERT OR UPDATE ON public.device_sessions
FOR EACH ROW
EXECUTE FUNCTION public.check_device_access();

-- ============================================================================
-- FUNCTION: sync_profile_updated_at()
-- Auto-update timestamp on profile changes
-- ============================================================================
CREATE OR REPLACE FUNCTION public.sync_profile_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.sync_profile_updated_at();

-- ============================================================================
-- FUNCTION: sync_courses_updated_at()
-- ============================================================================
CREATE OR REPLACE FUNCTION public.sync_courses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_courses_updated_at
BEFORE UPDATE ON public.courses
FOR EACH ROW
EXECUTE FUNCTION public.sync_courses_updated_at();

-- ============================================================================
-- FUNCTION: sync_videos_updated_at()
-- ============================================================================
CREATE OR REPLACE FUNCTION public.sync_videos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_videos_updated_at
BEFORE UPDATE ON public.videos
FOR EACH ROW
EXECUTE FUNCTION public.sync_videos_updated_at();

-- ============================================================================
-- FUNCTION: sync_progress_updated_at()
-- ============================================================================
CREATE OR REPLACE FUNCTION public.sync_progress_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_progress_updated_at
BEFORE UPDATE ON public.user_progress
FOR EACH ROW
EXECUTE FUNCTION public.sync_progress_updated_at();

-- ============================================================================
-- INDEXES for Performance
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_profiles_device_id ON public.profiles(device_id);
CREATE INDEX IF NOT EXISTS idx_videos_course_id ON public.videos(course_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id ON public.user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_video_id ON public.user_progress(video_id);
CREATE INDEX IF NOT EXISTS idx_device_sessions_user_id ON public.device_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_device_sessions_device_id ON public.device_sessions(device_id);

-- ============================================================================
-- SEED DATA (Optional)
-- ============================================================================
-- Insert sample courses
INSERT INTO public.courses (title, description, instructor, category, tier)
VALUES
  (
    'Volatility Forecasting with GARCH',
    'Master advanced volatility modeling using GARCH(1,1) models. Ideal for quantitative analysts and traders.',
    'Economicqsmaster',
    'quantitative',
    'premium'
  ),
  (
    'Time Series Analysis Fundamentals',
    'Learn the foundations of time series econometrics and statistical methods.',
    'Economicqsmaster',
    'quantitative',
    'free'
  ),
  (
    'Portfolio Optimization',
    'Optimize investment portfolios using modern portfolio theory and risk management.',
    'Economicqsmaster',
    'quantitative',
    'premium'
  )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- GRANT PERMISSIONS
-- ============================================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- ============================================================================
-- END OF SETUP SCRIPT
-- ============================================================================
