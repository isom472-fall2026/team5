CREATE OR REPLACE FUNCTION public.assign_student_placement(
    p_student_id INT,
    p_place_name VARCHAR
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
    updated_rows INTEGER;
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Sign in as the supervising professor for this student.';
    END IF;
    IF p_student_id IS NULL OR p_student_id < 1 THEN
        RAISE EXCEPTION 'The student_id is invalid.';
    END IF;
    IF NOT public.professor_owns_student_cycle(p_student_id) THEN
        RAISE EXCEPTION 'This student is not in your internship cycles.';
    END IF;
    IF p_place_name IS NULL OR length(btrim(p_place_name)) = 0 THEN
        RAISE EXCEPTION 'Choose an internship site.';
    END IF;
    IF NOT EXISTS (
        SELECT 1
        FROM public.employmentplace ep
        WHERE ep.place_name = btrim(p_place_name)
          AND ep.is_approved IS TRUE
    ) THEN
        RAISE EXCEPTION 'The selected internship site is not approved.';
    END IF;

    UPDATE public.student s
    SET employment_place = btrim(p_place_name)
    WHERE s.student_id = p_student_id
      AND s.employment_place IS NULL
      AND public.professor_owns_student_cycle(s.student_id);

    GET DIAGNOSTICS updated_rows = ROW_COUNT;
    IF updated_rows = 0 THEN
        RAISE EXCEPTION 'The student already has a placement or is no longer in your internship cycles.';
    END IF;
END;
$$;
REVOKE ALL ON FUNCTION public.assign_student_placement(INT, VARCHAR) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.assign_student_placement(INT, VARCHAR) TO authenticated;

CREATE OR REPLACE FUNCTION public.reject_student_site_preference(p_student_id INT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
    updated_rows INTEGER;
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Sign in as the supervising professor for this student.';
    END IF;
    IF p_student_id IS NULL OR p_student_id < 1 THEN
        RAISE EXCEPTION 'The student_id is invalid.';
    END IF;
    IF NOT public.professor_owns_student_cycle(p_student_id) THEN
        RAISE EXCEPTION 'This student is not in your internship cycles.';
    END IF;

    UPDATE public.student s
    SET employment_preference = NULL
    WHERE s.student_id = p_student_id
      AND s.employment_place IS NULL
      AND s.employment_preference IS NOT NULL
      AND public.professor_owns_student_cycle(s.student_id);

    GET DIAGNOSTICS updated_rows = ROW_COUNT;
    IF updated_rows = 0 THEN
        RAISE EXCEPTION 'The student has a final placement or no preference to reject.';
    END IF;
END;
$$;
REVOKE ALL ON FUNCTION public.reject_student_site_preference(INT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.reject_student_site_preference(INT) TO authenticated;
