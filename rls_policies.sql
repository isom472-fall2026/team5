ALTER TABLE CompanyChannel ENABLE ROW LEVEL SECURITY;
CREATE POLICY "CompanyChannel read policy" ON CompanyChannel FOR SELECT USING (true);

CREATE POLICY "Employment places can create channels" ON CompanyChannel FOR INSERT TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM EmploymentPlace ep
    WHERE ep.place_name = CompanyChannel.place_name
      AND ep.user_id = auth.uid()
  )
);

CREATE POLICY "Employment places can update their channels" ON CompanyChannel FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM EmploymentPlace ep
    WHERE ep.place_name = CompanyChannel.place_name
      AND ep.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM EmploymentPlace ep
    WHERE ep.place_name = CompanyChannel.place_name
      AND ep.user_id = auth.uid()
  )
);

CREATE POLICY "Employment places can delete their channels" ON CompanyChannel FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM EmploymentPlace ep
    WHERE ep.place_name = CompanyChannel.place_name
      AND ep.user_id = auth.uid()
  )
);
