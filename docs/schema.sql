-- =======================================================================================
-- 1. CLEANUP: DROP EVERYTHING FROM SCRATCH (Including new tables)
-- =======================================================================================
DROP TABLE IF EXISTS InternshipCertificate CASCADE;
DROP TABLE IF EXISTS DailyInternshipLog CASCADE;
DROP TABLE IF EXISTS CompanyChannel CASCADE;
DROP TABLE IF EXISTS AcceptanceDocument CASCADE;
DROP TABLE IF EXISTS InternshipEvaluation CASCADE;
DROP TABLE IF EXISTS InternshipFeedback CASCADE;
DROP TABLE IF EXISTS PlaceEnrolledinSemester CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS InternshipCycle CASCADE;
DROP TABLE IF EXISTS EmploymentPlace CASCADE;
DROP TABLE IF EXISTS SupervisingProfessor CASCADE;
DROP TYPE IF EXISTS semester_enum CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_student CASCADE;

-- =======================================================================================
-- 2. CREATE CUSTOM TYPES
-- =======================================================================================
CREATE TYPE semester_enum AS ENUM ('Fall', 'Spring', 'Summer');

-- =======================================================================================
-- 3. CREATE CORE TABLES
-- =======================================================================================

CREATE TABLE SupervisingProfessor (
    professor_id SERIAL PRIMARY KEY,
    name VARCHAR(150),
    email VARCHAR(255),
    department VARCHAR(100),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE TABLE EmploymentPlace (
    place_id SERIAL PRIMARY KEY,
    place_name VARCHAR(150) NOT NULL UNIQUE, -- Made UNIQUE to allow foreign key references from other tables
    phone_number VARCHAR(30),
    coordination_office VARCHAR(150),
    available_departments VARCHAR(255),
    email VARCHAR(100),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- New columns from Issues #13, #20, #37, #48
    sector VARCHAR(50), 
    target_major VARCHAR(100),
    is_approved BOOLEAN DEFAULT FALSE,
    opportunity_description TEXT,
    requirements TEXT,
    required_documents TEXT,
    company_requirements TEXT,
    last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE InternshipCycle (
    cycle_id SERIAL PRIMARY KEY,
    professor_id INT NOT NULL,
    place_name VARCHAR(150) NOT NULL,
    semester semester_enum NOT NULL,
    year INT NOT NULL,
    CONSTRAINT fk_professor
        FOREIGN KEY(professor_id) REFERENCES SupervisingProfessor(professor_id) ON DELETE CASCADE,
    CONSTRAINT fk_cycle_place
        FOREIGN KEY(place_name) REFERENCES EmploymentPlace(place_name) ON DELETE CASCADE
);

CREATE TABLE PlaceEnrolledinSemester (
    Place_id INT NOT NULL,
    Cycle_id INT NOT NULL,
    PRIMARY KEY (Place_id, Cycle_id),
    CONSTRAINT fk_place
        FOREIGN KEY(Place_id) REFERENCES EmploymentPlace(place_id) ON DELETE CASCADE,
    CONSTRAINT fk_cycle
        FOREIGN KEY(Cycle_id) REFERENCES InternshipCycle(cycle_id) ON DELETE CASCADE
);

CREATE TABLE Student (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(150),
    age INT,
    GPA DECIMAL(3, 2),
    major VARCHAR(100),
    student_email VARCHAR(255),
    phone_number VARCHAR(30),
    credits_passed INT,
    
    -- Updated column from Issue #33
    employment_preference VARCHAR(150), 
    
    employment_place VARCHAR(150),
    student_department VARCHAR(100),
    grade_set VARCHAR(100),
    Internship_cycle_id INT,
    CV BYTEA,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- New columns from Issue #23 (SKIPPED Issue #30 password_hash)
    civil_id VARCHAR(12) UNIQUE NOT NULL,
    profile_picture VARCHAR(255),
    cv_url VARCHAR(255),
    skills TEXT,

    CONSTRAINT fk_internship_cycle
        FOREIGN KEY(Internship_cycle_id) REFERENCES InternshipCycle(cycle_id) ON DELETE SET NULL,
    CONSTRAINT fk_employment_preference
        FOREIGN KEY(employment_preference) REFERENCES EmploymentPlace(place_name) ON DELETE SET NULL
);

-- =======================================================================================
-- 4. CREATE NEW TABLES FROM ISSUES
-- =======================================================================================

-- Issue #54: Provide Feedback on Internship Experience
CREATE TABLE InternshipFeedback (
    feedback_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Student(student_id) ON DELETE CASCADE,
    rating INT,
    comments TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Issue #25: Evaluate Training Site
CREATE TABLE InternshipEvaluation (
    evaluation_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Student(student_id) ON DELETE CASCADE,
    place_name VARCHAR(150) REFERENCES EmploymentPlace(place_name) ON DELETE CASCADE,
    professor_id INT REFERENCES SupervisingProfessor(professor_id) ON DELETE CASCADE,
    site_rating INT,
    supervisor_rating INT,
    feedback_comments TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Issue #49: Attach Acceptance Documents to Channels
CREATE TABLE AcceptanceDocument (
    document_id SERIAL PRIMARY KEY,
    place_name VARCHAR(150) REFERENCES EmploymentPlace(place_name) ON DELETE CASCADE,
    document_name VARCHAR(255),
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Issue #39: Create Company-Specific Internship Channels
CREATE TABLE CompanyChannel (
    channel_id SERIAL PRIMARY KEY,
    channel_name VARCHAR(150),
    place_name VARCHAR(150) REFERENCES EmploymentPlace(place_name) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Issue #34: Log Daily Internship Hours
CREATE TABLE DailyInternshipLog (
    log_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Student(student_id) ON DELETE CASCADE,
    work_date DATE,
    check_in_time TIME,
    check_out_time TIME,
    total_hours DECIMAL(5,2),
    approval_status VARCHAR(20) DEFAULT 'Pending',
    supervisor_notes TEXT
);

-- Issue #26: Request Internship Certificate
CREATE TABLE InternshipCertificate (
    certificate_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Student(student_id) ON DELETE CASCADE,
    request_date DATE DEFAULT CURRENT_DATE,
    verification_status VARCHAR(30) DEFAULT 'Pending Approval',
    issue_date DATE,
    certificate_file_path VARCHAR(255)
);

-- =======================================================================================
-- 5. ENABLE ROW LEVEL SECURITY (RLS)
-- =======================================================================================
ALTER TABLE Student ENABLE ROW LEVEL SECURITY;
ALTER TABLE SupervisingProfessor ENABLE ROW LEVEL SECURITY;
ALTER TABLE EmploymentPlace ENABLE ROW LEVEL SECURITY;
ALTER TABLE InternshipCycle ENABLE ROW LEVEL SECURITY;
ALTER TABLE PlaceEnrolledinSemester ENABLE ROW LEVEL SECURITY;

-- Applying RLS to new tables to prevent locked-out queries
ALTER TABLE InternshipFeedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE InternshipEvaluation ENABLE ROW LEVEL SECURITY;
ALTER TABLE AcceptanceDocument ENABLE ROW LEVEL SECURITY;
ALTER TABLE CompanyChannel ENABLE ROW LEVEL SECURITY;
ALTER TABLE DailyInternshipLog ENABLE ROW LEVEL SECURITY;
ALTER TABLE InternshipCertificate ENABLE ROW LEVEL SECURITY;

-- =======================================================================================
-- 6. CREATE RLS POLICIES
-- =======================================================================================
-- (Standard permissive authenticated access for standard reads, restricted writes for core tables)
CREATE POLICY "Students can view own profile" ON Student FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Students can update own profile" ON Student FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Authenticated users can view professors" ON SupervisingProfessor FOR SELECT TO authenticated USING (true);
CREATE POLICY "Professors can update own profile" ON SupervisingProfessor FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Authenticated users can view employment places" ON EmploymentPlace FOR SELECT TO authenticated USING (true);
CREATE POLICY "Employment places can update own profile" ON EmploymentPlace FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Authenticated users can view internship cycles" ON InternshipCycle FOR SELECT TO authenticated USING (true);
CREATE POLICY "Professors can manage their own internship cycles" ON InternshipCycle FOR ALL TO authenticated USING (professor_id IN (SELECT professor_id FROM SupervisingProfessor WHERE user_id = auth.uid()));

CREATE POLICY "Authenticated users can view place enrollments" ON PlaceEnrolledinSemester FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow modifications by authenticated users" ON PlaceEnrolledinSemester FOR ALL TO authenticated USING (true);

-- Base policies for new tables (Allows authenticated users to read/write, refine later as needed)
CREATE POLICY "Auth users can read feedback" ON InternshipFeedback FOR SELECT TO authenticated USING (true);
CREATE POLICY "Auth users can read evaluation" ON InternshipEvaluation FOR SELECT TO authenticated USING (true);
CREATE POLICY "Auth users can read documents" ON AcceptanceDocument FOR SELECT TO authenticated USING (true);
CREATE POLICY "Auth users can read channels" ON CompanyChannel FOR SELECT TO authenticated USING (true);
CREATE POLICY "Auth users can read logs" ON DailyInternshipLog FOR SELECT TO authenticated USING (true);
CREATE POLICY "Auth users can read certificates" ON InternshipCertificate FOR SELECT TO authenticated USING (true);

CREATE POLICY "Auth users can write to new tables" ON InternshipFeedback FOR ALL TO authenticated USING (true);
CREATE POLICY "Auth users can write to evaluations" ON InternshipEvaluation FOR ALL TO authenticated USING (true);
CREATE POLICY "Auth users can write to logs" ON DailyInternshipLog FOR ALL TO authenticated USING (true);

-- =======================================================================================
-- 7. AUTOMATED USER SIGNUP TRIGGER
-- =======================================================================================
-- Note: Dummy civil_id added since NOT NULL unique is required by Issue #23. 
-- In production, the user must provide civil_id during auth sign up meta data.
CREATE OR REPLACE FUNCTION public.handle_new_student()
RETURNS TRIGGER AS \$\$
BEGIN
  INSERT INTO public.Student (user_id, name, student_email, civil_id)
  VALUES (
    new.id, 
    COALESCE(new.raw_user_meta_data->>'name', 'New Student'), 
    new.email,
    COALESCE(new.raw_user_meta_data->>'civil_id', substring(new.id::text from 1 for 12)) 
  );
  RETURN NEW;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_student();
