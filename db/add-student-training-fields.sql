-- Apply to an existing database after db/schema.sql has been deployed.
BEGIN;

ALTER TABLE public.student
    ADD COLUMN IF NOT EXISTS completed_units INT
        GENERATED ALWAYS AS (credits_passed) STORED,
    ADD COLUMN IF NOT EXISTS learning_objective TEXT,
    ADD COLUMN IF NOT EXISTS objective_status VARCHAR(30);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'student_learning_objective_length'
          AND conrelid = 'public.student'::regclass
    ) THEN
        ALTER TABLE public.student
            ADD CONSTRAINT student_learning_objective_length
            CHECK (
                learning_objective IS NULL
                OR length(btrim(learning_objective)) BETWEEN 1 AND 500
            );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'student_objective_status_valid'
          AND conrelid = 'public.student'::regclass
    ) THEN
        ALTER TABLE public.student
            ADD CONSTRAINT student_objective_status_valid
            CHECK (
                objective_status IS NULL
                OR objective_status IN ('Pending', 'Approved', 'Revision Suggested')
            );
    END IF;
END;
$$;

COMMIT;
