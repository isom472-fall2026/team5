CREATE OR REPLACE FUNCTION public.get_open_issues_by_training_site()
RETURNS TABLE (
    training_site_name VARCHAR,
    open_issue_count BIGINT,
    total_issue_count BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM public.supervisingprofessor sp
        WHERE sp.user_id = auth.uid()
    ) THEN
        RAISE EXCEPTION 'This page is for the field training coordinator.'
            USING ERRCODE = '42501';
    END IF;

    RETURN QUERY
    SELECT
        COALESCE(s.employment_place, ic.place_name, 'Unassigned')::VARCHAR,
        COUNT(*) FILTER (WHERE ir.status <> 'Resolved'),
        COUNT(*)
    FROM public.internshipissuereport ir
    JOIN public.student s ON s.student_id = ir.student_id
    LEFT JOIN public.internshipcycle ic ON ic.cycle_id = s.internship_cycle_id
    GROUP BY 1
    ORDER BY 2 DESC, 3 DESC, 1 ASC;
END;
$$;

REVOKE ALL ON FUNCTION public.get_open_issues_by_training_site() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_open_issues_by_training_site() TO authenticated;
