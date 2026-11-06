# Academic Field Training System - Schema Overview

## What a Row Means (Table Entities)

* **SupervisingProfessor** (Primary Key: `professor_id`): A university faculty member responsible for overseeing and grading students during their internship.
* **EmploymentPlace** (Primary Key: `employment_place_id`): A registered corporate or government entity offering specific training opportunities for students.
* **InternshipCycle** (Primary Key: `cycle_id`): A specific academic term (e.g., Fall 2026) of the internship program managed by a designated professor.
* **PlaceEnrolledinSemester** (Primary Key: `(employment_place_id, cycle_id)`): A confirmed mapping that indicates a specific company is actively offering slots during a specific academic cycle.
* **Student** (Primary Key: `student_id`): An undergraduate registered in the system to apply for, track, and complete their field training requirement.
* **InternshipFeedback** (Primary Key: `feedback_id`): A student's post-internship reflections and general ratings of their overall experience.
* **InternshipEvaluation** (Primary Key: `evaluation_id`): A formal, structured assessment submitted by a student rating their specific training site and academic supervisor.
* **AcceptanceDocument** (Primary Key: `document_id`): A digital file confirming a student's official acceptance to a specific company.
* **CompanyChannel** (Primary Key: `channel_id`): A dedicated group workspace designed to cluster all students interning at the same employment site.
* **DailyInternshipLog** (Primary Key: `log_id`): A single day's attendance record documenting a student's check-in, check-out, and total hours worked.
* **InternshipCertificate** (Primary Key: `certificate_id`): A student's formal application for, and the system's digital record of, their final completion certificate.
* **WeeklyProgressReport** (Primary Key: `report_id`): A student's weekly hours and progress submission, unique to that student and Monday-starting reporting week.
* **SupervisorNotification** (Primary Key: `notification_id`): An in-app notification created for the supervising professor when a student submits a weekly progress report.
* **InternshipIssueReport** (Primary Key: `issue_report_id`): A student's categorized internship problem with a description and coordinator-managed status.
* **InternshipIssueNotification** (Primary Key: `notification_id`): An in-app notification sent to the supervising professor when a student reports an internship issue.

## How They Connect (Relationships)

* An **InternshipCycle** is managed by exactly one **SupervisingProfessor**.
* **PlaceEnrolledinSemester** acts as a bridge, linking many **EmploymentPlaces** to many **InternshipCycles** to define what opportunities are available when.
* A **Student** is tied to exactly one **InternshipCycle** for their grading term and points to one **EmploymentPlace** as their placement preference.
* A **Student** acts as the parent record for their own **InternshipFeedback**, **DailyInternshipLogs**, and **InternshipCertificates**.
* An **InternshipEvaluation** ties a single **Student**’s review back to both the **EmploymentPlace** they worked at and the **SupervisingProfessor** who graded them.
* An **AcceptanceDocument** and a **CompanyChannel** are directly attached to an **EmploymentPlace** to keep company-specific resources organized.
* A **WeeklyProgressReport** belongs to one **Student**; its notification is routed to the professor supervising that student's cycle.
* An **InternshipIssueReport** belongs to one **Student**; its notification is routed to the professor supervising that student's cycle.

## Security and Access (Row Level Security Policies)

* **Signed-in access:** Every policy targets authenticated users; anonymous users do not receive access through these policies.
* **Profiles and directories:** Students can read and update their own profile. Their supervising professor can read the student's profile. Signed-in users can read professor profiles and internship cycles. Employment places are readable when approved, owned by the signed-in account, assigned to that student's placement, or associated with that professor's cycle. A company account or a professor assigned to that place can update its information.
* **Cycle opportunities:** Signed-in users can read place enrollments so students can browse available opportunities. Only the professor responsible for a cycle can create, update, or delete its enrollment rows and manage that cycle.
* **Student records:** Students can read their own feedback, evaluations, daily logs, and certificate requests. Their supervising professor can also read those records. Students can submit and update their own feedback and evaluations, create their own pending logs, and update only their own pending logs. Supervising professors can review logs for their students and update certificate requests.
* **Company resources:** A student can read documents and channels for their assigned employment place. The employment-place account and a professor with a cycle for that place can also read and manage those resources.
* **Certificate requests:** Students can create a request in the pending state and cancel their own pending request. Supervising professors can review and issue certificates for students in their cycles.
* **Weekly reports:** Students can submit one report for the current Monday-starting week until Friday 23:59 Kuwait time. They and their supervising professor can read the report. Submission creates an in-app notification that only the assigned professor can read.
* **Internship issues:** Students can submit an issue with a category and description. Their supervising professor receives an in-app notification, can read the report, and can set its status to Submitted, Under review, or Resolved. Students can read their own report; report content cannot be changed after submission.
