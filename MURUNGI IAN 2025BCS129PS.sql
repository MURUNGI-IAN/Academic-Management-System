-- ============================================================
--  PROJECT   : Academic Management System
--  Database  : MySQL 8.0+
--  Author    : MURUNGI IAN
--  Reg. No.  : 2025/BCS/129/PS
--  Course    : DATABASE MANAGEMENT  SYSTEM
--  Date      : May 2026
-- ============================================================


-- ============================================================
-- SECTION 1: CLEAN SLATE — removes everything before rebuilding
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS departments;

DROP DATABASE IF EXISTS academic_management;

SET FOREIGN_KEY_CHECKS = 1;

CREATE DATABASE academic_management;
USE academic_management;


-- ============================================================
-- SECTION 2: TABLE DEFINITIONS
-- ============================================================

-- Stores university departments
CREATE TABLE departments (
    department_id      INT AUTO_INCREMENT PRIMARY KEY,
    department_name    VARCHAR(100) NOT NULL,
    head_of_department VARCHAR(100)
);

-- Stores degree programs offered by departments
CREATE TABLE programs (
    program_id     INT AUTO_INCREMENT PRIMARY KEY,
    program_name   VARCHAR(100) NOT NULL,
    duration_years INT          NOT NULL,
    department_id  INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Stores teaching staff records
CREATE TABLE faculty (
    faculty_id    INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) UNIQUE,
    phone         VARCHAR(20),
    department_id INT,
    hire_date     DATE         NOT NULL DEFAULT (CURRENT_DATE),
    title         VARCHAR(50),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Stores academic semester periods
CREATE TABLE semesters (
    semester_id   INT AUTO_INCREMENT PRIMARY KEY,
    semester_name VARCHAR(50)  NOT NULL,
    start_date    DATE         NOT NULL,
    end_date      DATE         NOT NULL,
    academic_year VARCHAR(20)  NOT NULL,
    CONSTRAINT chk_semester_dates CHECK (end_date > start_date)
);

-- Stores student records
CREATE TABLE students (
    student_id          INT AUTO_INCREMENT PRIMARY KEY,
    registration_number VARCHAR(30)  UNIQUE NOT NULL,
    first_name          VARCHAR(50)  NOT NULL,
    last_name           VARCHAR(50)  NOT NULL,
    date_of_birth       DATE,
    gender              ENUM('Male', 'Female', 'Other'),
    email               VARCHAR(100) UNIQUE,
    phone               VARCHAR(20),
    admission_date      DATE         DEFAULT (CURRENT_DATE),
    program_id          INT,
    current_semester_id INT,
    FOREIGN KEY (program_id)          REFERENCES programs(program_id),
    FOREIGN KEY (current_semester_id) REFERENCES semesters(semester_id)
);

-- Stores course offerings linked to departments and faculty
CREATE TABLE courses (
    course_id     INT AUTO_INCREMENT PRIMARY KEY,
    course_code   VARCHAR(20)  UNIQUE NOT NULL,
    course_name   VARCHAR(100) NOT NULL,
    credits       INT          NOT NULL,
    department_id INT,
    faculty_id    INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (faculty_id)    REFERENCES faculty(faculty_id)
);

-- Records which students are enrolled in which courses per semester
CREATE TABLE enrollments (
    enrollment_id   INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT  NOT NULL,
    course_id       INT  NOT NULL,
    semester_id     INT  NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    status          ENUM('Active', 'Dropped', 'Completed') DEFAULT 'Active',
    FOREIGN KEY (student_id)  REFERENCES students(student_id),
    FOREIGN KEY (course_id)   REFERENCES courses(course_id),
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id),
    UNIQUE KEY unique_enrollment (student_id, course_id, semester_id)
);

-- Stores one grade per enrollment
CREATE TABLE grades (
    grade_id        INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id   INT UNIQUE NOT NULL,
    grade_value     ENUM('A','A-','B+','B','B-','C+','C','C-','D','F') NOT NULL,
    numerical_grade DECIMAL(4,2),
    grade_date      DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);


-- ============================================================
-- SECTION 3: SAMPLE DATA
-- ============================================================

INSERT INTO departments (department_name, head_of_department) VALUES
    ('Computer Science',        'Dr. Sarah Nakato'),
    ('Business Administration', 'Prof. John Mukasa');

INSERT INTO programs (program_name, duration_years, department_id) VALUES
    ('Bachelor of Information Technology',  4, 1),
    ('Bachelor of Business Administration', 3, 2);

INSERT INTO faculty (first_name, last_name, email, department_id, title, hire_date) VALUES
    ('Michael', 'Kato',    'mkato@kmu.ac.ug',    1, 'Senior Lecturer', '2018-01-15'),
    ('Grace',   'Nabwire', 'gnabwire@kmu.ac.ug', 1, 'Lecturer',        '2020-03-01');

INSERT INTO semesters (semester_name, start_date, end_date, academic_year) VALUES
    ('Semester 1 2025/2026', '2025-08-01', '2025-12-20', '2025/2026');

INSERT INTO courses (course_code, course_name, credits, department_id, faculty_id) VALUES
    ('CS101',  'Introduction to Programming', 4, 1, 1),
    ('CS102',  'Database Systems',            4, 1, 2),
    ('BUS101', 'Principles of Management',    3, 2, NULL);

INSERT INTO students (registration_number, first_name, last_name, gender, program_id) VALUES
    ('BIT/2023/001', 'Amina', 'Nalwanga',  'Female', 1),
    ('BIT/2023/002', 'David', 'Ssempijja', 'Male',   1);

INSERT INTO enrollments (student_id, course_id, semester_id) VALUES
    (1, 1, 1),
    (1, 2, 1);

INSERT INTO grades (enrollment_id, grade_value, numerical_grade) VALUES
    (1, 'A',  92.00),
    (2, 'B+', 78.50);


-- ============================================================
-- SECTION 4: QUERIES
-- ============================================================

-- Query 1: All students with their program and department
SELECT
    s.registration_number,
    s.first_name,
    s.last_name,
    p.program_name,
    d.department_name
FROM       students    s
JOIN       programs    p ON s.program_id    = p.program_id
JOIN       departments d ON p.department_id = d.department_id;

-- Query 2: All courses with assigned lecturer (unassigned shown as TBA)
SELECT
    c.course_code,
    c.course_name,
    c.credits,
    COALESCE(CONCAT(f.first_name, ' ', f.last_name), 'TBA') AS lecturer
FROM      courses c
LEFT JOIN faculty f ON c.faculty_id = f.faculty_id;

-- Query 3: Student enrollments with grades for Semester 1
SELECT
    s.registration_number,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_name,
    e.status,
    g.grade_value,
    g.numerical_grade
FROM       enrollments e
JOIN       students    s ON e.student_id    = s.student_id
JOIN       courses     c ON e.course_id     = c.course_id
LEFT JOIN  grades      g ON e.enrollment_id = g.enrollment_id
WHERE e.semester_id = 1;

-- Query 4: Average grade per course
SELECT
    c.course_code,
    c.course_name,
    ROUND(AVG(g.numerical_grade), 2) AS average_grade
FROM       grades      g
JOIN       enrollments e ON g.enrollment_id = e.enrollment_id
JOIN       courses     c ON e.course_id     = c.course_id
GROUP BY   c.course_id, c.course_code, c.course_name;

-- Query 5: Total number of students per program
SELECT
    p.program_name,
    COUNT(*) AS total_students
FROM     students s
JOIN     programs p ON s.program_id = p.program_id
GROUP BY p.program_id, p.program_name;

-- Query 6: GPA ranking — highest to lowest
SELECT
    s.registration_number,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    ROUND(AVG(g.numerical_grade), 2)       AS gpa
FROM       students    s
JOIN       enrollments e ON s.student_id    = e.student_id
JOIN       grades      g ON e.enrollment_id = g.enrollment_id
GROUP BY   s.student_id, s.registration_number, full_name
ORDER BY   gpa DESC;


-- ============================================================
-- END OF PROJECT
-- ============================================================
