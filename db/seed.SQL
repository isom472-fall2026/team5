INSERT INTO DailyInternshipLog (student_id, work_date, check_in_time, check_out_time, total_hours, approval_status, supervisor_notes) 
VALUES 
(1, '2026-10-01', '08:00:00', '16:00:00', 8.00, 'Approved', 'أداء ممتاز'), 
(2, '2026-10-01', '09:00:00', '17:00:00', 8.00, 'Pending', 'يحتاج للمزيد من التركيز');
INSERT INTO CompanyChannel (channel_name, place_name) 
VALUES 
('قناة الاستفسارات العامة', 'شركة أ'), 
('قناة قسم الموارد البشرية', 'شركة b'), 
('قناة الدعم الفني', 'شركة ج');
INSERT INTO InternshipCertificate (student_id, request_date, verification_status, issue_date, certificate_file_path) 
VALUES 
(1, '2026-10-15', 'Approved', '2026-10-16', '/certs/cert1.pdf'), 
(2, '2026-10-15', 'Pending Approval', NULL, NULL);
