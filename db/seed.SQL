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

