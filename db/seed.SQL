
INSERT INTO SupervisingProfessor (name, email, department)
VALUES
('Dr. Ahmed', 'ahmed@university.edu', 'Computer Science'),
('Dr. Sara', 'sara@university.edu', 'Business Administration'),
('Prof. Lee', 'lee@university.edu', 'Engineering');

INSERT INTO EmploymentPlace (place_name, email, sector, target_major) 
VALUES 
('Company A', 'info@companya.com', 'Telecommunications', 'Information Systems'),
('Company B', 'contact@companyb.com', 'Financial Sector', 'Business Administration'),
('Company C', 'support@companyc.com', 'Education Sector', 'Accounting');
INSERT INTO AcceptanceDocument (place_name, document_name, file_path) 
VALUES 
('Company A', 'Job Offer', '/docs/doc1.pdf'), 
('Company B', 'Training Agreement', '/docs/doc2.pdf'), 
('Company C', 'Acceptance Letter', '/docs/doc3.pdf');

INSERT INTO DailyInternshipLog (student_id, work_date, check_in_time, check_out_time, total_hours, approval_status, supervisor_notes) 
VALUES 
(1, '2026-10-01', '08:00:00', '16:00:00', 8.00, 'Approved', 'Excellent performance'), 
(2, '2026-10-01', '09:00:00', '17:00:00', 8.00, 'Pending', 'Needs more focus');

INSERT INTO CompanyChannel (channel_name, place_name)
VALUES ('General Inquiries Channel', 'Company A');



