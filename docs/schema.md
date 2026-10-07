# Academic Field Training System - Schema Overview

## What a Row Means (Table Entities)
* **SupervisingProfessor**: A university faculty member responsible for overseeing and grading students during their internship.
* **EmploymentPlace**: A registered corporate or government entity offering specific training opportunities for students.
* **InternshipCycle**: A specific academic term (e.g., Fall 2026) of the internship program managed by a designated professor.
* **PlaceEnrolledinSemester**: A confirmed mapping that indicates a specific company is actively offering slots during a specific academic cycle.
* **Student**: An undergraduate registered in the system to apply for, track, and complete their field training requirement.
* **InternshipFeedback**: A student's post-internship reflections and general ratings of their overall experience.
* **InternshipEvaluation**: A formal, structured assessment submitted by a student rating their specific training site and academic supervisor.
* **AcceptanceDocument**: A digital file confirming a student's official acceptance to a specific company.
* **CompanyChannel**: A dedicated group workspace designed to cluster all students interning at the same employment site.
* **DailyInternshipLog**: A single day's attendance record documenting a student's check-in, check-out, and total hours worked.
* **InternshipCertificate**: A student's formal application for, and the system's digital record of, their final completion certificate.

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
* **Open Submissions:** Any logged-in user may currently read and write to the evaluations, feedback, daily logs, and enrollment tables so students face zero friction when logging hours or submitting required coursework.
