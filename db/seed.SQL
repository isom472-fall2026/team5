INSERT INTO CompanyChannel (channel_name, place_name)
VALUES
('Technical Consulting Channel', 'Company A'),
('HR Department Channel', 'Company B'),
('Technical Support Channel', 'Company C');

INSERT INTO InternshipCertificate (student_id, request_date, verification_status, issue_date, certificate_file_path)
VALUES
(1, '2026-10-15', 'Approved', '2026-10-16', './certs/cert1.pdf'),
(2, '2026-10-15', 'Pending Approval', NULL, NULL);
INSERT INTO SupervisingProfessor (name, email, department)
VALUES
    ('Dr. Lina Sample', 'lina.sample@example.test', 'Information Systems'),
    ('Dr. Omar Sample', 'omar.sample@example.test', 'Business Administration'),
    ('Dr. Maya Sample', 'maya.sample@example.test', 'Accounting');

INSERT INTO EmploymentPlace (
    place_name,
    phone_number,
    coordination_office,
    available_departments,
    email,
    sector,
    target_major,
    is_approved,
    opportunity_description,
    requirements,
    required_documents,
    company_requirements
)
VALUES
    (
        'Sample Technology Group',
        '+00000000001',
        'Training Desk',
        'Information Systems, Computer Science',
        'training@sample-tech.example.test',
        'Private',
        'Information Systems',
        TRUE,
        'Synthetic technology internship for database testing.',
        'Complete 90 credit units.',
        'CV, Civil ID copy',
        'Basic database coursework'
    ),
    (
        'Sample Finance Office',
        '+00000000002',
        'Internship Desk',
        'Business Administration, Finance',
        'internships@sample-finance.example.test',
        'Private',
        'Business Administration',
        TRUE,
        'Synthetic finance internship for database testing.',
        'Complete 90 credit units.',
        'CV, Civil ID copy',
        'Interest in financial services'
    ),
    (
        'Sample Research Center',
        '+00000000003',
        'Student Liaison',
        'Accounting, Business Administration',
        'students@sample-research.example.test',
        'Government',
        'Accounting',
        TRUE,
        'Synthetic research placement for database testing.',
        'Complete 90 credit units.',
        'CV, Civil ID copy',
        'Basic accounting coursework'
    );

INSERT INTO InternshipCycle (professor_id, place_name, semester, year)
VALUES
    (
        (SELECT professor_id FROM SupervisingProfessor WHERE email = 'lina.sample@example.test'),
        'Sample Technology Group',
        'Fall',
        2026
    ),
    (
        (SELECT professor_id FROM SupervisingProfessor WHERE email = 'omar.sample@example.test'),
        'Sample Finance Office',
        'Fall',
        2026
    ),
    (
        (SELECT professor_id FROM SupervisingProfessor WHERE email = 'maya.sample@example.test'),
        'Sample Research Center',
        'Fall',
        2026
    );

INSERT INTO PlaceEnrolledinSemester (Place_id, Cycle_id)
VALUES
    (
        (SELECT place_id FROM EmploymentPlace WHERE place_name = 'Sample Technology Group'),
        (
            SELECT cycle_id FROM InternshipCycle
            WHERE place_name = 'Sample Technology Group' AND semester = 'Fall' AND year = 2026
        )
    ),
    (
        (SELECT place_id FROM EmploymentPlace WHERE place_name = 'Sample Finance Office'),
        (
            SELECT cycle_id FROM InternshipCycle
            WHERE place_name = 'Sample Finance Office' AND semester = 'Fall' AND year = 2026
        )
    ),
    (
        (SELECT place_id FROM EmploymentPlace WHERE place_name = 'Sample Research Center'),
        (
            SELECT cycle_id FROM InternshipCycle
            WHERE place_name = 'Sample Research Center' AND semester = 'Fall' AND year = 2026
        )
    );

INSERT INTO Student (
    name,
    age,
    GPA,
    major,
    student_email,
    phone_number,
    credits_passed,
    employment_preference,
    employment_place,
    student_department,
    Internship_cycle_id,
    civil_id,
    skills
)
VALUES
    (
        'Amina Sample',
        21,
        3.45,
        'Information Systems',
        'amina.sample@example.test',
        '+00000000101',
        96,
        'Sample Technology Group',
        'Sample Technology Group',
        'Information Systems',
        (
            SELECT cycle_id FROM InternshipCycle
            WHERE place_name = 'Sample Technology Group' AND semester = 'Fall' AND year = 2026
        ),
        'TESTSTU00001',
        'SQL, data analysis'
    ),
    (
        'Yousef Sample',
        22,
        3.20,
        'Business Administration',
        'yousef.sample@example.test',
        '+00000000102',
        102,
        'Sample Finance Office',
        'Sample Finance Office',
        'Business Administration',
        (
            SELECT cycle_id FROM InternshipCycle
            WHERE place_name = 'Sample Finance Office' AND semester = 'Fall' AND year = 2026
        ),
        'TESTSTU00002',
        'Excel, reporting'
    ),
    (
        'Mariam Sample',
        20,
        3.75,
        'Accounting',
        'mariam.sample@example.test',
        '+00000000103',
        90,
        'Sample Research Center',
        'Sample Research Center',
        'Accounting',
        (
            SELECT cycle_id FROM InternshipCycle
            WHERE place_name = 'Sample Research Center' AND semester = 'Fall' AND year = 2026
        ),
        'TESTSTU00003',
        'Bookkeeping, analysis'
    );

INSERT INTO InternshipFeedback (student_id, rating, comments)
VALUES
    (
        (SELECT student_id FROM Student WHERE student_email = 'amina.sample@example.test'),
        4,
        'Synthetic feedback: the training activities were useful.'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'yousef.sample@example.test'),
        5,
        'Synthetic feedback: the placement helped build practical skills.'
    );

INSERT INTO InternshipEvaluation (
    student_id,
    place_name,
    professor_id,
    site_rating,
    supervisor_rating,
    feedback_comments
)
VALUES
    (
        (SELECT student_id FROM Student WHERE student_email = 'amina.sample@example.test'),
        'Sample Technology Group',
        (SELECT professor_id FROM SupervisingProfessor WHERE email = 'lina.sample@example.test'),
        4,
        5,
        'Synthetic evaluation for database testing.'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'yousef.sample@example.test'),
        'Sample Finance Office',
        (SELECT professor_id FROM SupervisingProfessor WHERE email = 'omar.sample@example.test'),
        5,
        4,
        'Synthetic evaluation for database testing.'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'mariam.sample@example.test'),
        'Sample Research Center',
        (SELECT professor_id FROM SupervisingProfessor WHERE email = 'maya.sample@example.test'),
        4,
        4,
        'Synthetic evaluation for database testing.'
    );

INSERT INTO AcceptanceDocument (place_name, document_name, file_path)
VALUES
    ('Sample Technology Group', 'Synthetic training agreement', 'test-files/sample-tech-agreement.pdf'),
    ('Sample Finance Office', 'Synthetic acceptance letter', 'test-files/sample-finance-acceptance.pdf'),
    ('Sample Research Center', 'Synthetic placement guide', 'test-files/sample-research-guide.pdf');

INSERT INTO CompanyChannel (channel_name, place_name)
VALUES
    ('Sample Technology Interns', 'Sample Technology Group'),
    ('Sample Finance Interns', 'Sample Finance Office'),
    ('Sample Research Interns', 'Sample Research Center');

INSERT INTO DailyInternshipLog (
    student_id,
    work_date,
    check_in_time,
    check_out_time,
    total_hours,
    approval_status,
    supervisor_notes
)
VALUES
    (
        (SELECT student_id FROM Student WHERE student_email = 'amina.sample@example.test'),
        '2026-10-05',
        '08:00:00',
        '16:00:00',
        8.00,
        'Approved',
        'Synthetic approved test log.'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'yousef.sample@example.test'),
        '2026-10-05',
        '09:00:00',
        '17:00:00',
        8.00,
        'Pending',
        'Synthetic pending test log.'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'mariam.sample@example.test'),
        '2026-10-05',
        '08:30:00',
        '16:30:00',
        8.00,
        'Approved',
        'Synthetic approved test log.'
    );

INSERT INTO WeeklyProgressReport (student_id, week_start, weekly_hours, progress_details)
VALUES
    (
        (SELECT student_id FROM Student WHERE student_email = 'amina.sample@example.test'),
        '2026-10-19',
        32.00,
        'Synthetic progress report: completed database testing tasks and documented results.'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'yousef.sample@example.test'),
        '2026-10-19',
        30.50,
        'Synthetic progress report: reviewed financial reports and practiced data validation.'
    );

INSERT INTO InternshipIssueReport (student_id, category, description, status)
VALUES
    (
        (SELECT student_id FROM Student WHERE student_email = 'amina.sample@example.test'),
        'Workload',
        'Synthetic test issue: the assigned task volume needs review.',
        'Submitted'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'yousef.sample@example.test'),
        'Supervision',
        'Synthetic test issue: request a regular supervisor check-in.',
        'Under review'
    );

INSERT INTO InternshipCertificate (student_id, verification_status)
VALUES
    (
        (SELECT student_id FROM Student WHERE student_email = 'amina.sample@example.test'),
        'Pending Approval'
    ),
    (
        (SELECT student_id FROM Student WHERE student_email = 'yousef.sample@example.test'),
        'Pending Approval'
    );
