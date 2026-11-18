-- Reproducible testing accounts for the three authenticated personas.
-- Run this in the Supabase SQL Editor after db/schema.sql and db/seed.SQL.
-- Emails and passwords are intentionally documented in README.md.

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

DO $$
DECLARE
    account_id UUID;
BEGIN
    -- Student account: Amina Sample
    SELECT id INTO account_id
    FROM auth.users
    WHERE email = 'amina.sample.test@example.test';

    IF account_id IS NULL THEN
        account_id := extensions.gen_random_uuid();
        INSERT INTO auth.users (
            instance_id,
            id,
            aud,
            role,
            email,
            encrypted_password,
            email_confirmed_at,
            raw_app_meta_data,
            raw_user_meta_data,
            created_at,
            updated_at,
            is_anonymous
        ) VALUES (
            '00000000-0000-0000-0000-000000000000',
            account_id,
            'authenticated',
            'authenticated',
            'amina.sample.test@example.test',
            extensions.crypt('Student-7mK4!nR2pX9q', extensions.gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}'::jsonb,
            '{"name":"Amina Sample"}'::jsonb,
            NOW(),
            NOW(),
            FALSE
        );
    ELSE
        UPDATE auth.users
        SET encrypted_password = extensions.crypt(
                'Student-7mK4!nR2pX9q',
                extensions.gen_salt('bf')
            ),
            email_confirmed_at = COALESCE(email_confirmed_at, NOW()),
            raw_app_meta_data = '{"provider":"email","providers":["email"]}'::jsonb,
            raw_user_meta_data = '{"name":"Amina Sample"}'::jsonb,
            updated_at = NOW()
        WHERE id = account_id;
    END IF;

    INSERT INTO auth.identities (
        id,
        user_id,
        identity_data,
        provider,
        provider_id,
        last_sign_in_at,
        created_at,
        updated_at
    )
    SELECT
        extensions.gen_random_uuid(),
        account_id,
        jsonb_build_object(
            'sub', account_id::text,
            'email', 'amina.sample.test@example.test',
            'email_verified', true,
            'phone_verified', false
        ),
        'email',
        account_id::text,
        NOW(),
        NOW(),
        NOW()
    WHERE NOT EXISTS (
        SELECT 1
        FROM auth.identities
        WHERE provider = 'email'
          AND provider_id = account_id::text
    );

    UPDATE public.Student
    SET user_id = account_id,
        name = 'Amina Sample',
        student_email = 'amina.sample.test@example.test'
    WHERE student_id = (
        SELECT student_id
        FROM public.Student
        WHERE student_email = 'amina.sample.test@example.test'
           OR student_email = 'amina.sample@example.test'
        ORDER BY
            CASE WHEN student_email = 'amina.sample@example.test' THEN 0 ELSE 1 END,
            student_id
        LIMIT 1
    );

    DELETE FROM public.Student
    WHERE student_email = 'amina.sample.test@example.test'
      AND EXISTS (
          SELECT 1 FROM public.Student
          WHERE civil_id = 'TESTSTU00001'
      )
      AND student_id <> (
          SELECT student_id
          FROM public.Student
          WHERE civil_id = 'TESTSTU00001'
          LIMIT 1
      );

    -- Professor account: Dr. Lina Sample
    SELECT id INTO account_id
    FROM auth.users
    WHERE email = 'lina.sample.test@example.test';

    IF account_id IS NULL THEN
        account_id := extensions.gen_random_uuid();
        INSERT INTO auth.users (
            instance_id, id, aud, role, email, encrypted_password,
            email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
            created_at, updated_at, is_anonymous
        ) VALUES (
            '00000000-0000-0000-0000-000000000000',
            account_id,
            'authenticated',
            'authenticated',
            'lina.sample.test@example.test',
            extensions.crypt('Professor-4D!vN8cT3hR6', extensions.gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}'::jsonb,
            '{"name":"Dr. Lina Sample"}'::jsonb,
            NOW(),
            NOW(),
            FALSE
        );
    ELSE
        UPDATE auth.users
        SET encrypted_password = extensions.crypt(
                'Professor-4D!vN8cT3hR6',
                extensions.gen_salt('bf')
            ),
            email_confirmed_at = COALESCE(email_confirmed_at, NOW()),
            raw_app_meta_data = '{"provider":"email","providers":["email"]}'::jsonb,
            raw_user_meta_data = '{"name":"Dr. Lina Sample"}'::jsonb,
            updated_at = NOW()
        WHERE id = account_id;
    END IF;

    INSERT INTO auth.identities (
        id, user_id, identity_data, provider, provider_id,
        last_sign_in_at, created_at, updated_at
    )
    SELECT
        extensions.gen_random_uuid(),
        account_id,
        jsonb_build_object(
            'sub', account_id::text,
            'email', 'lina.sample.test@example.test',
            'email_verified', true,
            'phone_verified', false
        ),
        'email',
        account_id::text,
        NOW(),
        NOW(),
        NOW()
    WHERE NOT EXISTS (
        SELECT 1 FROM auth.identities
        WHERE provider = 'email' AND provider_id = account_id::text
    );

    UPDATE public.SupervisingProfessor
    SET user_id = account_id,
        name = 'Dr. Lina Sample',
        email = 'lina.sample.test@example.test'
    WHERE professor_id = (
        SELECT professor_id
        FROM public.SupervisingProfessor
        WHERE email = 'lina.sample.test@example.test'
           OR email = 'lina.sample@example.test'
        ORDER BY
            CASE WHEN email = 'lina.sample@example.test' THEN 0 ELSE 1 END,
            professor_id
        LIMIT 1
    );

    DELETE FROM public.Student
    WHERE student_email = 'lina.sample.test@example.test';

    -- Internship-site account: Sample Technology Group
    SELECT id INTO account_id
    FROM auth.users
    WHERE email = 'training.test@example.test';

    IF account_id IS NULL THEN
        account_id := extensions.gen_random_uuid();
        INSERT INTO auth.users (
            instance_id, id, aud, role, email, encrypted_password,
            email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
            created_at, updated_at, is_anonymous
        ) VALUES (
            '00000000-0000-0000-0000-000000000000',
            account_id,
            'authenticated',
            'authenticated',
            'training.test@example.test',
            extensions.crypt('InternSite-9K!bL5wV2xQ7', extensions.gen_salt('bf')),
            NOW(),
            '{"provider":"email","providers":["email"]}'::jsonb,
            '{"name":"Sample Technology Group Training Desk"}'::jsonb,
            NOW(),
            NOW(),
            FALSE
        );
    ELSE
        UPDATE auth.users
        SET encrypted_password = extensions.crypt(
                'InternSite-9K!bL5wV2xQ7',
                extensions.gen_salt('bf')
            ),
            email_confirmed_at = COALESCE(email_confirmed_at, NOW()),
            raw_app_meta_data = '{"provider":"email","providers":["email"]}'::jsonb,
            raw_user_meta_data = '{"name":"Sample Technology Group Training Desk"}'::jsonb,
            updated_at = NOW()
        WHERE id = account_id;
    END IF;

    INSERT INTO auth.identities (
        id, user_id, identity_data, provider, provider_id,
        last_sign_in_at, created_at, updated_at
    )
    SELECT
        extensions.gen_random_uuid(),
        account_id,
        jsonb_build_object(
            'sub', account_id::text,
            'email', 'training.test@example.test',
            'email_verified', true,
            'phone_verified', false
        ),
        'email',
        account_id::text,
        NOW(),
        NOW(),
        NOW()
    WHERE NOT EXISTS (
        SELECT 1 FROM auth.identities
        WHERE provider = 'email' AND provider_id = account_id::text
    );

    UPDATE public.EmploymentPlace
    SET user_id = account_id,
        email = 'training.test@example.test'
    WHERE place_id = (
        SELECT place_id
        FROM public.EmploymentPlace
        WHERE place_name = 'Sample Technology Group'
        LIMIT 1
    );

    DELETE FROM public.Student
    WHERE student_email = 'training.test@example.test';
END;
$$;
