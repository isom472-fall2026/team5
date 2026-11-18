-- Prevent students from changing their assigned site or choosing an unapproved preference.
CREATE OR REPLACE FUNCTION public.validate_student_employment_preference()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
    IF auth.uid() = OLD.user_id
       AND NEW.employment_place IS DISTINCT FROM OLD.employment_place THEN
        RAISE EXCEPTION 'The final placement is managed by the coordinator.';
    END IF;

    IF NEW.employment_preference IS DISTINCT FROM OLD.employment_preference THEN
        IF OLD.employment_place IS NOT NULL THEN
            RAISE EXCEPTION 'The preferred site cannot be changed after a final placement is assigned.';
        END IF;

        IF NEW.employment_preference IS NOT NULL
           AND NOT EXISTS (
               SELECT 1
               FROM public.employmentplace ep
               WHERE ep.place_name = NEW.employment_preference
                 AND ep.is_approved IS TRUE
           ) THEN
            RAISE EXCEPTION 'The preferred site must be an approved internship site.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS validate_student_employment_preference ON public.student;
CREATE TRIGGER validate_student_employment_preference
BEFORE UPDATE OF employment_preference, employment_place ON public.student
FOR EACH ROW
EXECUTE FUNCTION public.validate_student_employment_preference();
