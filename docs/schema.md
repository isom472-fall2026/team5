# Academic Field Training System — Schema Overview

This document describes the tables and access rules defined in [`db/schema.sql`](../db/schema.sql).
SQL identifiers are unquoted, so PostgreSQL stores names such as `Student` and
`UniversityAnnouncement` in lowercase.

## Tables

### Accounts and placements

* **`SupervisingProfessor`** (`professor_id`): University faculty and cycle owners. The current schema has no separate coordinator table or role; coordinator actions use the assigned cycle-owner account.
* **`EmploymentPlace`** (`place_id`): A training site, its account, approval status, contact information, opportunities, and requirements.
* **`InternshipCycle`** (`cycle_id`): A semester and year managed by one supervising professor and associated with one training site.
* **`PlaceEnrolledinSemester`** (`place_id`, `cycle_id`): A bridge between training sites and internship cycles.
* **`Student`** (`student_id`): Student profile, account link, cycle, preference, and placement. `credits_passed` is the stored credit count used by the application; `completed_units` is a generated alias of that value. `learning_objective` stores the student's optional objective, and `objective_status` is `Pending`, `Approved`, or `Revision Suggested`.
* **`InternshipApplication`** (`application_id`): A student's application to a training site and its decision status.
* **`ApplicationNotification`** (`notification_id`): A status-change notification for a student.
* **`NotificationPreference`** (`student_id`): The student's preferences for application-status notifications.

### Training records and resources

* **`InternshipFeedback`** (`feedback_id`): A student's general post-internship rating and comments.
* **`InternshipEvaluation`** (`evaluation_id`): A student's structured site and supervisor ratings with written feedback. This is the evaluation table; there is no separate `evaluation` table.
* **`AcceptanceDocument`** (`document_id`): A document attached to an employment place. This is the document table used by the application; there is no separate `acceptance_documents` table.
* **`CompanyChannel`** (`channel_id`): A channel associated with an employment place.
* **`DailyInternshipLog`** (`log_id`): A student's daily check-in and check-out record. The database calculates `total_hours`.
* **`InternshipCertificate`** (`certificate_id`): A student's certificate request and its review status.
* **`WeeklyProgressReport`** (`report_id`): A student's weekly hours and progress details, unique per student and Monday-starting week.
* **`SupervisorNotification`** (`notification_id`): A notification sent to the supervising professor when a weekly report is submitted.
* **`InternshipIssueReport`** (`issue_report_id`): A categorized student issue and its status.
* **`InternshipIssueNotification`** (`notification_id`): A notification sent to the supervising professor when a student reports an issue.
* **`UniversityAnnouncement`** (`announcement_id`): An announcement with an event date, optional time and location, and audience.
* **`StudentInquiry`** (`inquiry_id`): A message from a student to a supervisor or coordinator.

## Relationships

* An **`InternshipCycle`** belongs to one **`SupervisingProfessor`** and one **`EmploymentPlace`**.
* **`PlaceEnrolledinSemester`** links **`EmploymentPlace`** rows to **`InternshipCycle`** rows.
* A **`Student`** may be linked to one **`InternshipCycle`**, one preferred **`EmploymentPlace`**, and one final placement.
* Student feedback, evaluations, daily logs, certificate requests, weekly reports, issue reports, applications, and inquiries refer to a **`Student`**.
* Evaluations also refer to the training site and supervising professor. Acceptance documents and company channels refer to an employment place.
* Weekly-report and issue notifications refer to their report and to the responsible supervising professor.
* Application notifications and preferences refer to a student's application or student profile.

## Security and access

Row Level Security is enabled for the tables that contain account-specific or operational records. Policies grant authenticated users access only to the records allowed by their account and relationships.

* Students can view and update their own profile and submit their own applications, feedback, evaluations, pending daily logs, weekly reports, issues, and inquiries.
* Supervising professors can view records for students in cycles they own and review their students' applications, attendance, certificates, and issue statuses.
* Supervising professors can view aggregate open and total issue counts for all training sites; the report does not expose issue details.
* Training-site accounts can manage their own site information and company resources, and record attendance for students assigned to their site.
* Approved training sites and internship cycles are readable to signed-in users where needed for opportunity selection.
* A student's `employment_preference` can reference only an approved training site. Students cannot change a final placement; placement assignment is restricted to the supervising professor who owns that student's cycle.
* Students and their assigned professors can read student-specific reports and records. Issue-report content cannot be changed after submission; assigned professors can update its status.
* University announcements are readable to signed-in users.

## Existing database migration

For an existing Supabase database, apply [`db/add-student-training-fields.sql`](../db/add-student-training-fields.sql)
to add the learning-objective fields and generated `completed_units` column, and
[`db/issue-216-open-issues-per-site.sql`](../db/issue-216-open-issues-per-site.sql) to add the
coordinator issue-summary function. The evaluation, announcement, and acceptance-document
tables already exist in `db/schema.sql`; do not create parallel tables for them.

## Issue analytics

The `get_open_issues_by_training_site` function returns only aggregate counts to authenticated
supervising professors. Apply [`db/issue-216-open-issues-per-site.sql`](../db/issue-216-open-issues-per-site.sql)
to add the function to an existing Supabase database; new databases receive it from
[`db/schema.sql`](../db/schema.sql).
