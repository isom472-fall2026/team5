-- db/test_data.sql — sample data so every page shows something for the test accounts.
-- Run in the Supabase SQL Editor AFTER db/schema.sql, db/seed.SQL and db/testing_accounts.sql.
-- Safe to run again: it clears the sample rows it created before inserting them.
-- Test-only data. Do not use for real students.

DO $$
DECLARE
    v_prof_id     INT;
    v_main_place  VARCHAR(150) := 'Sample Technology Group';
    v_cycle_id    INT;
    v_amina       INT;
    v_s2          INT;
    v_s3          INT;
    v_app_id      INT;
    v_monday      DATE := date_trunc('week', timezone('Asia/Kuwait', now()))::date;
BEGIN
    ------------------------------------------------------------------
    -- 1. Training sites (approved, with full details)
    ------------------------------------------------------------------
    INSERT INTO public.employmentplace
        (place_name, phone_number, coordination_office, available_departments, email,
         sector, target_major, is_approved, opportunity_description, requirements,
         required_documents, company_requirements)
    VALUES
        (v_main_place, '22220000', 'Sharq, Kuwait City - Training Office', 'IT, Data Analysis, HR',
         'training.test@example.test', 'private', 'MIS', TRUE,
         'Summer internship in the IT and data teams.', 'Excel and basic SQL',
         'CV, Civil ID, Personal Photo', 'MIS or Finance students with 90+ credits and GPA 2.5 or higher.'),
        ('Sample Ministry of Finance', '22221111', 'Murqab - Government Complex', 'Budgeting, Accounting',
         'mof.sample@example.test', 'government', 'Finance', TRUE,
         'Internship in the budgeting department.', 'Accounting basics',
         'CV, Civil ID', 'Finance or Accounting students with 90+ credits.'),
        ('Sample National Oil Company', '22222222', 'Ahmadi - Head Office', 'Operations, Supply Chain',
         'oil.sample@example.test', 'public', 'MIS', TRUE,
         'Internship in operations and supply chain.', 'Teamwork and reporting',
         'CV, Civil ID, Personal Photo', 'MIS or Operations students with 90+ credits.')
    ON CONFLICT (place_name) DO UPDATE
    SET is_approved = TRUE,
        sector = EXCLUDED.sector,
        target_major = EXCLUDED.target_major,
        available_departments = EXCLUDED.available_departments,
        coordination_office = EXCLUDED.coordination_office,
        opportunity_description = EXCLUDED.opportunity_description,
        requirements = EXCLUDED.requirements,
        required_documents = EXCLUDED.required_documents,
        company_requirements = EXCLUDED.company_requirements,
        last_updated_at = CURRENT_TIMESTAMP;

    ------------------------------------------------------------------
    -- 2. Professor Lina and her Fall 2026 internship cycle
    ------------------------------------------------------------------
    SELECT professor_id INTO v_prof_id
    FROM public.supervisingprofessor
    WHERE email = 'lina.sample.test@example.test'
    LIMIT 1;
    IF v_prof_id IS NULL THEN
        RAISE EXCEPTION 'Run db/testing_accounts.sql first: professor Lina was not found.';
    END IF;

    UPDATE public.supervisingprofessor SET phone_number = '99990000', department = 'Information Systems'
    WHERE professor_id = v_prof_id;

    SELECT cycle_id INTO v_cycle_id
    FROM public.internshipcycle
    WHERE professor_id = v_prof_id AND place_name = v_main_place AND semester = 'Fall' AND year = 2026
    LIMIT 1;
    IF v_cycle_id IS NULL THEN
        INSERT INTO public.internshipcycle (professor_id, place_name, semester, year)
        VALUES (v_prof_id, v_main_place, 'Fall', 2026)
        RETURNING cycle_id INTO v_cycle_id;
    END IF;

    -- All three sites are offered this semester (Training Opportunities page, #13)
    INSERT INTO public.placeenrolledinsemester (place_id, cycle_id)
    SELECT ep.place_id, v_cycle_id
    FROM public.employmentplace ep
    WHERE ep.place_name IN (v_main_place, 'Sample Ministry of Finance', 'Sample National Oil Company')
    ON CONFLICT DO NOTHING;

    ------------------------------------------------------------------
    -- 3. Students: Amina (test account) + two sample classmates
    ------------------------------------------------------------------
    SELECT student_id INTO v_amina
    FROM public.student
    WHERE student_email = 'amina.sample.test@example.test'
    LIMIT 1;
    IF v_amina IS NULL THEN
        RAISE EXCEPTION 'Run db/testing_accounts.sql first: student Amina was not found.';
    END IF;

    -- Clear the placement first so the preference can be set, then assign it
    UPDATE public.student SET employment_place = NULL WHERE student_id = v_amina;
    UPDATE public.student
    SET major = 'MIS', gpa = 3.20, credits_passed = 96, phone_number = '99998888',
        student_department = 'Information Systems', internship_cycle_id = v_cycle_id,
        employment_preference = v_main_place, cv_url = 'https://example.test/amina-cv.pdf',
        skills = 'Excel, SQL, presentation'
    WHERE student_id = v_amina;
    UPDATE public.student SET employment_place = v_main_place WHERE student_id = v_amina;

    INSERT INTO public.student (name, major, gpa, credits_passed, student_email, phone_number, civil_id, internship_cycle_id)
    VALUES ('Sara Sample', 'MIS', 3.50, 100, 'sara.sample@example.test', '99997777', 'TESTSTU00002', v_cycle_id),
           ('Fahad Sample', 'Finance', 2.90, 92, 'fahad.sample@example.test', '99996666', 'TESTSTU00003', v_cycle_id)
    ON CONFLICT (civil_id) DO UPDATE SET internship_cycle_id = EXCLUDED.internship_cycle_id;

    SELECT student_id INTO v_s2 FROM public.student WHERE civil_id = 'TESTSTU00002';
    SELECT student_id INTO v_s3 FROM public.student WHERE civil_id = 'TESTSTU00003';
    UPDATE public.student SET employment_place = NULL WHERE student_id IN (v_s2, v_s3);
    UPDATE public.student SET employment_preference = 'Sample National Oil Company', employment_place = NULL WHERE student_id = v_s2;
    UPDATE public.student SET employment_place = 'Sample Ministry of Finance' WHERE student_id = v_s3;
    UPDATE public.student SET employment_place = 'Sample National Oil Company' WHERE student_id = v_s2;

    ------------------------------------------------------------------
    -- 4. Clear old sample rows for these students (so the script can run again)
    ------------------------------------------------------------------
    DELETE FROM public.dailyinternshiplog      WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.weeklyprogressreport    WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.internshipissuereport   WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.internshipevaluation    WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.internshipapplication   WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.internshipcertificate   WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.studentinquiry          WHERE student_id IN (v_amina, v_s2, v_s3);
    DELETE FROM public.companychannel          WHERE channel_name LIKE '%(sample)';
    DELETE FROM public.universityannouncement  WHERE title LIKE '%(sample)';

    ------------------------------------------------------------------
    -- 5. Attendance (#34) and weekly reports
    ------------------------------------------------------------------
    INSERT INTO public.dailyinternshiplog (student_id, work_date, check_in_time, check_out_time, approval_status, supervisor_notes)
    VALUES (v_amina, v_monday - 7, '08:00', '14:00', 'Approved', 'On time'),
           (v_amina, v_monday - 6, '08:00', '15:00', 'Approved', NULL),
           (v_amina, v_monday - 5, '08:30', '14:30', 'Approved', 'Good work on the report'),
           (v_amina, v_monday - 1, '09:00', '13:00', 'Pending', NULL),
           (v_s2,    v_monday - 7, '08:00', '14:00', 'Approved', NULL);

    INSERT INTO public.weeklyprogressreport (student_id, week_start, weekly_hours, progress_details, submitted_at)
    VALUES (v_amina, v_monday - 14, 18, 'Learned the internal reporting system and cleaned a sales dataset.', now() - interval '10 days'),
           (v_amina, v_monday - 7,  19, 'Built an Excel dashboard for the IT team and presented it.', now() - interval '3 days');

    ------------------------------------------------------------------
    -- 6. Reported issues (Reported Issues page + analytics #216)
    ------------------------------------------------------------------
    INSERT INTO public.internshipissuereport (student_id, category, description, status, submitted_at)
    VALUES (v_amina, 'Workload',    'I am asked to work past my agreed hours most days.', 'Submitted',    now() - interval '6 days'),
           (v_amina, 'Supervision', 'My workplace supervisor was away for a week.',        'Resolved',     now() - interval '20 days'),
           (v_s2,    'Safety',      'No safety training before working on site.',         'Under review', now() - interval '4 days'),
           (v_s2,    'Workplace',   'No desk or computer assigned yet.',                  'Submitted',    now() - interval '2 days'),
           (v_s3,    'Other',       'Unclear tasks in the first week.',                   'Resolved',     now() - interval '15 days');

    ------------------------------------------------------------------
    -- 7. Site reviews (#25, #43)
    ------------------------------------------------------------------
    INSERT INTO public.internshipevaluation (student_id, place_name, professor_id, site_rating, supervisor_rating, feedback_comments)
    VALUES (v_amina, v_main_place,                 v_prof_id, 4, 5, 'Friendly team and real tasks.'),
           (v_s2,    'Sample National Oil Company', v_prof_id, 3, 3, 'Good experience but slow start.'),
           (v_s3,    'Sample Ministry of Finance',  v_prof_id, 5, 4, 'Very well organised training plan.');

    ------------------------------------------------------------------
    -- 8. Application status + notification (#42)
    ------------------------------------------------------------------
    INSERT INTO public.internshipapplication (student_id, place_name, status, decision_note, decided_at)
    VALUES (v_amina, v_main_place, 'Approved', 'Welcome to the IT team.', now() - interval '25 days')
    RETURNING application_id INTO v_app_id;
    INSERT INTO public.applicationnotification (student_id, application_id, message)
    VALUES (v_amina, v_app_id, 'Your internship application to ' || v_main_place || ' was approved. Note: Welcome to the IT team.');
    INSERT INTO public.internshipapplication (student_id, place_name, status)
    VALUES (v_amina, 'Sample National Oil Company', 'Pending');

    ------------------------------------------------------------------
    -- 9. Company channels (#39), announcements (#36), certificate (#26), inquiry (#38)
    ------------------------------------------------------------------
    INSERT INTO public.companychannel (channel_name, place_name)
    VALUES (v_main_place || ' interns (sample)', v_main_place),
           ('Ministry of Finance interns (sample)', 'Sample Ministry of Finance');

    INSERT INTO public.universityannouncement (title, event_date, event_time, location, audience)
    VALUES ('CV writing workshop (sample)',        CURRENT_DATE + 3,  '11:00', 'CBA Hall 2',      'interns'),
           ('Mid-internship meeting (sample)',     CURRENT_DATE + 7,  '10:00', 'OSTA Office',     'interns'),
           ('Final report deadline (sample)',      CURRENT_DATE + 21, NULL,    'Online',          'interns');

    INSERT INTO public.internshipcertificate (student_id, verification_status)
    VALUES (v_amina, 'Pending Approval');

    INSERT INTO public.studentinquiry (student_id, recipient_role, recipient_email, message_content)
    VALUES (v_amina, 'supervisor', 'lina.sample.test@example.test', 'Can we meet this week to review my progress?');
END;
$$;