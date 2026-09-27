# Proposal

## 1. The client, and how you reach them

Dr. Asmaa Alfadhel, Coordinator of the Academic Field Training Unit at the College.  
We communicate via her university email and in-person weekly coordination meetings at the OSTA office.

## 2. What happens today, and what goes wrong

Students find placements by contacting companies directly or reading department lists. Students hand registration forms to the training coordinator. During training, students record hours on sign-in sheets at company sites. Supervisors write evaluations at the completion of training. Supervisors transmit these forms through email, post, or student delivery. The breakdown occurs when forms sit in email inboxes or on desks, so the coordinator lacks records to enter grades before deadlines. No coordination between the professor and the office and the training partners regarding student placement, grading and nature of work.

## 3. Who is better off, and how you would know

Students, academic coordinators, and external workplace mentors gain a single point of interaction and status tracking.  
We know it worked when the coordinator closes the semester with zero missing evaluation forms and zero untracked attendance records.  
Grade approvals for training completion are finalized within forty-eight hours of the semester conclusion.

## 4. What the system does, in outline

* Browse approved training organizations and submit placement applications online.
* Log daily attendance hours and submit weekly training summary reports.
* Review submitted attendance entries and approve completed student hours.
* Fill and submit milestone evaluation forms with scoring rubrics for trainees.
* Broadcast automated reminder notifications for approaching report and evaluation deadlines.
* Export cohort attendance records and final performance summaries for academic grading.

## 5. What it records

| Entity | Attributes Recorded | Relationships |
|---|---|---|
| User Profile | User ID, full name, role (student, coordinator, mentor), email, phone | Associated with placements, reports, and evaluations |
| Training Opportunity | Placement ID, organization name, address, available capacity, description | Linked to approved student applicants |
| Attendance Record | Record ID, date, check-in time, check-out time, hours logged | Created by student; validated by company mentor |
| Training Report | Report ID, week number, task summary, submission timestamp | Submitted by student; reviewed by academic coordinator |
| Evaluation Submission | Evaluation ID, rubric ratings, mentor feedback, completion date | Authored by mentor; attached to student training record |

## 6. In scope by the final week — and what is not

**In scope by the final week:**
* Web interface for students to browse organizations and submit training applications.
* Daily attendance logging module with workplace supervisor approval actions.
* Weekly progress report submission and coordinator review view.
* Supervisor evaluation submission form based on standard evaluation criteria.
* Automated notification triggers for pending report submissions and overdue evaluations.

**Deliberately leaving out:**
* Native mobile applications for iOS or Android.
* Bi-directional synchronization with university student information systems (SIS).
* GPS-based geofencing or biometric verification for physical attendance tracking.
* Financial stipend processing or commercial contract management between parties.

## 7. After the semester

The department coordinator can deploy the system to pilot the subsequent summer internship cohort.  
A succeeding student project team can implement university single sign-on (SSO) and develop push-notification integrations for mobile devices.

## 8. What you told the client this is

We told the client that this is an undergraduate capstone prototype built by student developers, focused strictly on core placement, tracking, and evaluation workflows.  
We specified that development ends with the academic semester, after which we hand over the source repository, setup guide, and documentation without ongoing maintenance commitments.
