Academic Management System

Author: MURUNGI IAN
Registration No.: 2025/BCS/129/PS
Course: Database Management System
Institution: Mbarara University of Science and Technology
Database: MySQL 8.0 and above
Date: May 2026

---

**Project Overview**

The Academic Management System is a relational database project designed to digitize and streamline core administrative operations at a university. The system covers the full lifecycle of academic records, from department and programme setup through faculty assignment, student registration, course enrolment, and grade management.

---

**Project Objectives**

Design a normalised relational database schema that eliminates data redundancy. Implement referential integrity through well-defined foreign key constraints. Store and manage student, faculty, course, enrolment, and grade records. Produce meaningful analytical queries including GPA rankings and course averages. Demonstrate mastery of SQL DDL and DML statements in MySQL 8.0.

---

**Database Tables**

departments — Stores university departments, each with a name and head of department.

programs — Holds degree programmes offered by the university, linked to a department with a duration in years.

faculty — Contains teaching staff records including contact details, academic title, hire date, and department link.

semesters — Defines academic periods with a check constraint ensuring the end date is always after the start date.

students — The central table storing student records including registration number, personal details, programme, and current semester.

courses — Lists all course offerings with a course code, credit value, and optional links to a department and faculty member.

enrollments — Records which student is enrolled in which course during which semester, with a composite unique key preventing duplicate enrolments.

grades — Stores exactly one grade per enrolment, including a letter grade and a numerical score for GPA calculations.

---

**Analytical Queries**

Query 1 — Student Directory: Lists all students with their enrolled programme and parent department.

Query 2 — Course Lecturer Report: Shows every course and its assigned lecturer, displaying TBA for unassigned courses.

Query 3 — Enrolment and Grades: Displays student enrolments for Semester 1 together with grade values and numerical scores.

Query 4 — Average Grade per Course: Calculates the mean numerical grade for each course across all students.

Query 5 — Students per Programme: Counts the total number of students enrolled in each degree programme.

Query 6 — GPA Ranking: Aggregates each student grades into a GPA and ranks students from highest to lowest.

---

**How to Run the Project**

Install MySQL 8.0 or above and ensure the service is running. Open your preferred MySQL client such as MySQL Workbench, DBeaver, or the command line. Open the file MURUNGI_IAN_2025BCS129PS.sql in your client. Execute the entire script from top to bottom in a single run. The script will drop any previous version of the database, create a fresh one, build all tables, insert sample data, and run all six analytical queries automatically. Review the result sets at the bottom of the script to confirm everything is working correctly.

---

**Technical Highlights**

The script opens with SET FOREIGN_KEY_CHECKS = 0 so it can be re-run safely at any time without errors. A check constraint on the semesters table ensures end dates are always valid at the database level. A composite unique key on enrollments prevents a student from being enrolled in the same course twice in the same semester. COALESCE in Query 2 shows TBA instead of null for unassigned courses. LEFT JOIN in Query 3 ensures students with no grade yet still appear in the report. The GPA ranking query uses GROUP BY and ORDER BY together to produce a live performance leaderboard.

---

**System Requirements**

MySQL Server version 8.0 or higher. A MySQL client such as MySQL Workbench, DBeaver, HeidiSQL, or the mysql command-line tool. Sufficient privileges to create and drop databases and tables.

---

MURUNGI IAN — Reg. No. 2025/BCS/129/PS — Database Management System — May 2026
