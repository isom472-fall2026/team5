-- Student
ALTER TABLE Student ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Student read policy" ON Student FOR SELECT USING (true);

-- EmploymentPlace
ALTER TABLE EmploymentPlace ENABLE ROW LEVEL SECURITY;
CREATE POLICY "EmploymentPlace read policy" ON EmploymentPlace FOR SELECT USING (true);

-- SupervisingProfessor
ALTER TABLE SupervisingProfessor ENABLE ROW LEVEL SECURITY;
CREATE POLICY "SupervisingProfessor read policy" ON SupervisingProfessor FOR SELECT USING (true);

-- InternshipCycle
ALTER TABLE InternshipCycle ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipCycle read policy" ON InternshipCycle FOR SELECT USING (true);

-- PlaceEnrolledInSemester
ALTER TABLE PlaceEnrolledInSemester ENABLE ROW LEVEL SECURITY;
CREATE POLICY "PlaceEnrolledInSemester read policy" ON PlaceEnrolledInSemester FOR SELECT USING (true);

-- InternshipEvaluation
ALTER TABLE InternshipEvaluation ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipEvaluation read policy" ON InternshipEvaluation FOR SELECT USING (true);

-- InternshipFeedback
ALTER TABLE InternshipFeedback ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipFeedback read policy" ON InternshipFeedback FOR SELECT USING (true);

-- AcceptanceDocument
ALTER TABLE AcceptanceDocument ENABLE ROW LEVEL SECURITY;
CREATE POLICY "AcceptanceDocument read policy" ON AcceptanceDocument FOR SELECT USING (true);

-- CompanyChannel
ALTER TABLE CompanyChannel ENABLE ROW LEVEL SECURITY;
CREATE POLICY "CompanyChannel read policy" ON CompanyChannel FOR SELECT USING (true);

-- DailyInternshipLog
ALTER TABLE DailyInternshipLog ENABLE ROW LEVEL SECURITY;
CREATE POLICY "DailyInternshipLog read policy" ON DailyInternshipLog FOR SELECT USING (true);

-- InternshipCertificate
ALTER TABLE InternshipCertificate ENABLE ROW LEVEL SECURITY;
CREATE POLICY "InternshipCertificate read policy" ON InternshipCertificate FOR SELECT USING (true);
