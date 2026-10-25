ALTER TABLE Student ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Student read policy" ON Student FOR SELECT USING (true);

ALTER TABLE EmploymentPlace ENABLE ROW LEVEL SECURITY;
CREATE POLICY "EmploymentPlace read policy" ON EmploymentPlace FOR SELECT USING (true);

ALTER TABLE SupervisingProfessor ENABLE ROW LEVEL SECURITY;
CREATE POLICY "SupervisingProfessor read policy" ON SupervisingProfessor FOR SELECT USING (true);

ALTER TABLE InternshipCycle ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipCycle read policy" ON InternshipCycle FOR SELECT USING (true);

ALTER TABLE PlaceEnrolledInSemester ENABLE ROW LEVEL SECURITY;
CREATE POLICY "PlaceEnrolledInSemester read policy" ON PlaceEnrolledInSemester FOR SELECT USING (true);

ALTER TABLE InternshipEvaluation ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipEvaluation read policy" ON InternshipEvaluation FOR SELECT USING (true);

ALTER TABLE InternshipFeedback ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipFeedback read policy" ON InternshipFeedback FOR SELECT USING (true);

ALTER TABLE AcceptanceDocument ENABLE ROW LEVEL SECURITY;
CREATE POLICY "AcceptanceDocument read policy" ON AcceptanceDocument FOR SELECT USING (true);

ALTER TABLE CompanyChannel ENABLE ROW LEVEL SECURITY;
CREATE POLICY "CompanyChannel read policy" ON CompanyChannel FOR SELECT USING (true);

ALTER TABLE DailyInternshipLog ENABLE ROW LEVEL SECURITY;
CREATE POLICY "DailyInternshipLog read policy" ON DailyInternshipLog FOR SELECT USING (true);

ALTER TABLE InternshipCertificate ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipCertificate read policy" ON InternshipCertificate FOR SELECT USING (true);
