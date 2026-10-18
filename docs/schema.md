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

## How They Connect (Relationships)

* An **InternshipCycle** is managed by exactly one **SupervisingProfessor**.
* **PlaceEnrolledinSemester** acts as a bridge, linking many **EmploymentPlaces** to many **InternshipCycles** to define what opportunities are available when.
* A **Student** is tied to exactly one **InternshipCycle** for their grading term and points to one **EmploymentPlace** as their placement preference.
* A **Student** acts as the parent record for their own **InternshipFeedback**, **DailyInternshipLogs**, and **InternshipCertificates**.
* An **InternshipEvaluation** ties a single **Student**’s review back to both the **EmploymentPlace** they worked at and the **SupervisingProfessor** who graded them.
* An **AcceptanceDocument** and a **CompanyChannel** are directly attached to an **EmploymentPlace** to keep company-specific resources organized.

## Security and Access (Row Level Security Policies)

* **Profile Privacy:** Students, Professors, and Employment Places can update only their own profile data, ensuring no user can overwrite another's personal information.
* **Public Directories:** Any logged-in user may read the lists of professors, employment places, and internship cycles so students can freely research and choose their placements.
* **Cycle Management:** Professors may only modify or delete the specific internship cycles they personally own, preventing faculty members from accidentally altering each other's semesters.
* **Open Reads, Scoped Writes:** Anyone may read semester placements, feedback, evaluations, and daily logs. Only the professor responsible for a cycle may change its company enrollments; students may create and update their own feedback and evaluations; students may create and update their own pending logs, while the professor responsible for their cycle may review those logs. Deletes are not granted by these policies.
