-- Story #54: Update Student Contact Information

CREATE OR REPLACE FUNCTION update_student_contact(
    p_student_id UUID,
    p_phone_number TEXT,
    p_student_email TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
BEGIN
    -- Check student ID
    IF p_student_id IS NULL THEN
        RAISE EXCEPTION 'Invalid student ID';
    END IF;

    -- Validate email
    IF p_student_email IS NULL
       OR p_student_email !~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    THEN
        RAISE EXCEPTION 'Invalid email format';
    END IF;

    -- Validate phone number
    IF p_phone_number IS NULL
       OR p_phone_number !~ '^[0-9+ -]{8,15}$'
    THEN
        RAISE EXCEPTION 'Invalid phone number';
    END IF;

    -- Update student contact
    UPDATE public.students
    SET phone_number = p_phone_number,
        student_email = p_student_email
    WHERE student_id = p_student_id
      AND student_id = auth.uid();

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invalid student ID or unauthorized';
    END IF;

    RETURN 'Contact information updated successfully';
END;
$$;
