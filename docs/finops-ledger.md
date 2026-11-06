# FinOps ledger

What the AI work cost you, and what you changed because of it.

This ledger lives in the repository and is committed. It is never kept in a spreadsheet, a
chat thread, or anywhere else. It is checked as **present and current** — it is not scored
on how accurate the numbers are. An honest rough figure beats a precise invented one.

The FinOps Lead keeps it. Every member supplies their own rows.


## The plan — written in Phase 2

*Which assistant or model you use for which kind of work, and what your limit is. Three or
four lines. Revisit it in Phase 4 and say whether it held.*

| Kind of work | What we use | Why |
|---|---|---|
| Managing backlog and user story requirements | Claude, ChatGPT, and Gemini | To refine user stories, verify acceptance criteria, and track model usage per task. | 
| Managing backlog and user story requirements | Claude, ChatGPT, and Gemini |To refine user stories, verify acceptance criteria, and track model usage per task| 
| Coding and repository maintenance | VS Code agents and Antigravity | To accelerate development, manage merge conflicts, and automate documentation |  
## Phase 2

| Story | Assistant used | What it used (tokens, requests, or your own estimate) | What we gave it (files, story, schema) | What we would do differently |
|---|---|---|---|---|
|  Optionally Define Learning Objectives #35| Claude |~500 tokens  |User story and acceptance criteria  | Provide more specific examples of learning objectives |
|  Log Daily Internship Hours #34|ChatGPT |~800 tokens |User story and acceptance criteria |Add validation rules for check-in and check-out times |
| Select Preferred Internship Sites #33 | Gemini | ~600 tokens | User story and acceptance criteria | Provide more details on internship site availability and selection criteria up-front |

We work using the agents feature in vs code + antigravity and record token usage each session and story



## Phase 3

| Story | Assistant used | What it used (tokens, requests, or your own estimate) | What we gave it (files, story, schema) | What we would do differently |
|---|---|---|---|---|
| View Approved Training Opportunities #13 | Claude | ~3,000 tokens | User story, acceptance criteria and the employmentplace table | Give it the full list of required columns at the start |
| View Placement Details #15 | Claude | ~2,500 tokens | User story and acceptance criteria | Ask for the empty and error messages in the first prompt |
| View Available Internship Cycles #18 | Claude | ~2,500 tokens | User story and the internshipcycle table | Check the file name has no spaces before committing |
| View Company Requirements #20 | Claude | ~2,500 tokens | User story, acceptance criteria and the company requirement columns | Match the column names to db/schema.sql before generating code |
| View Evaluation Criteria #21 | Claude | ~4,000 tokens | User story, acceptance criteria and the evaluation table columns | Give it the exact column names from db/schema.sql from the start |
| View Student Profile Information #23 | Claude | ~2,500 tokens | User story and the student table | Test the page with a signed-in student before opening the pull request |
| View Contact Information for Support #31 | Claude | ~2,000 tokens | User story and the OSTA contact details | Link the page from the home page in the same pull request |
| Access Main Navigation Menu #46 | Claude | ~2,500 tokens | User story and the list of page file names | Check every link path before merging |
| View Reported Issues and Their Status #140 | Claude | ~3,500 tokens | User story, acceptance criteria and the internshipissuereport table | Ask it to handle the empty and error states first |
| View Internship Progress Summary #141 | Claude | ~3,500 tokens | User story, acceptance criteria and the hours and cycle tables | Test with a signed-in student before opening the pull request |
| No story — Phase 3 delivery note and scope changes | Claude | ~3,000 tokens | Issue list, instructor feedback and the Phase 2 delivery note | Keep the issue list up to date during the sprint |
| Log Daily Internship Hours #34 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Optionally Define Learning Objectives #35 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Receive Internship-Related University Notifications #36 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Select Suitable Internship Site #37 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Contact Supervisor or Coordinator #38 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Create Company-Specific Internship Channels #39 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Manage Personal Data Privacy #40 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Prompt for Notification Permissions #41 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| View Internship Site Reviews #43 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| View Internship Grade and Evaluation #44 | Gemini and ChatGPT | Not recorded | User story and acceptance criteria | Record the token estimate after each session |
| Submit Weekly Progress Report #12 | Antigravity and ChatGPT | Not recorded | User story, acceptance criteria and db/schema.sql | Record the token estimate after each session |
| Report Internship Issues #19 | Antigravity and ChatGPT | Not recorded | User story, acceptance criteria and db/schema.sql | Record the token estimate after each session |
| Provide Student Information for Sign In #30 | Antigravity and ChatGPT | Not recorded | User story, acceptance criteria and db/schema.sql | Record the token estimate after each session |


We work using the agents feature in VS Code + Antigravity and record token usage each session and story.
## Phase 4

| Story | Assistant used | What it used (tokens, requests, or your own estimate) | What we gave it (files, story, schema) | What we would do differently |
|---|---|---|---|---|
|  |  |  |  |  |

## Phase 5

| Story | Assistant used | What it used (tokens, requests, or your own estimate) | What we gave it (files, story, schema) | What we would do differently |
|---|---|---|---|---|
|  |  |  |  |  |

## Phase 6

| Story | Assistant used | What it used (tokens, requests, or your own estimate) | What we gave it (files, story, schema) | What we would do differently |
|---|---|---|---|---|
|  |  |  |  |  |
