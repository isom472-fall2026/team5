-- Story #49: Attach Acceptance Documents to Channels

CREATE TABLE IF NOT EXISTS public.acceptance_documents (
    document_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID NOT NULL,
    document_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_type TEXT NOT NULL,
    version_number INTEGER NOT NULL DEFAULT 1,
    uploaded_by UUID NOT NULL DEFAULT auth.uid(),
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT valid_document_name
        CHECK (length(trim(document_name)) > 0),

    CONSTRAINT valid_file_path
        CHECK (length(trim(file_path)) > 0),

    CONSTRAINT valid_file_type
        CHECK (
            lower(file_type) IN (
                'pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'
            )
        )
);

-- Track document access
CREATE TABLE IF NOT EXISTS public.document_access_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL
        REFERENCES public.acceptance_documents(document_id),
    accessed_by UUID NOT NULL DEFAULT auth.uid(),
    accessed_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable row level security
ALTER TABLE public.acceptance_documents
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.document_access_logs
ENABLE ROW LEVEL SECURITY;
