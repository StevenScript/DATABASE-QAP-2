--************************************--
-- PROBLEM ONE: UNIVERSITY ENROLLMENT --
--************************************--

-- STEVEN NORRIS --
--  10-12-2024   --

----------------------------------------
--    TABLE CREATION                  --
----------------------------------------

-- STUDENTS TABLE --
CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    enrollment_date DATE
);

-- PROFESSOR TABLE --
CREATE TABLE IF NOT EXISTS professors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100)
);

-- COURSES TABLE --
CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT,
    professor_id INTEGER REFERENCES professors(id)
);

-- ENROLLMENT TABLE --
CREATE TABLE IF NOT EXISTS enrollments (
    student_id INTEGER REFERENCES students(id),
    course_id INTEGER REFERENCES courses(id),
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id)
);

----------------------------------------
--    ADD INFO TO SCRIPT              --
----------------------------------------


-- IINSERT data into the STUDENTS table
INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('Duke', 'Nukem', 'Duke.Nukem@universitymail.com', '2024-02-04'),
('Alex', 'Ample', 'Alex.Ample@universitymail.com', '2024-04-03'),
('Noah', 'Scuses', 'Noah.Scuses@universitymail.com', '2024-07-15'),
('Barry', 'Mealive', 'Barry.Mealive@universitymail.com', '2024-07-24'),
('Ida', 'Student', 'Ida.Student@universitymail.com', '2024-09-01');

-- Confirmation query for students
SELECT * FROM students;


-- INSERT information into the PROFESSOR table
INSERT INTO professors (first_name, last_name, department) VALUES
('Khan', 'Pewter', 'Computer Science'),
('Heisen', 'Burg', 'Chemistry'),
('Jenny', 'Talia', 'Body Anatomy'),
('Frasier', 'Wordswright', 'English Literature');

-- Confirmation query for professors
SELECT * FROM professors;


-- Insert data into the courses table
-- Professor IDs are sequential(Serial); 1 for Khan, 2 Heisen, etc
INSERT INTO courses (course_name, course_description, professor_id) VALUES
('Introduction to Computer Science', 'Fundamentals of SQL and pgAdmin4.', 1),
('Chemistry 101', 'Basics of Cold Fusion.', 2),
('Meta-Body Anatomy', 'How to Grow Extra Limbs.', 3),
('English And Its Derivates', 'Words; The Discourse', 4);


-- Confirmation query for courses
SELECT * FROM courses;


-- Insert data into the enrollments table
-- Student IDs and Course IDs start from 1 and increment by 1(Serial)
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-02-04'),  -- Duke Nukem enrolls in Introduction to Computer Science
(1, 2, '2024-02-04'),  -- Duke Nukem enrolls in Chemistry 101
(2, 1, '2024-04-03'),  -- Alex Ample enrolls in Introduction to Computer Science
(3, 3, '2024-07-15'),  -- Noah Scuses enrolls in Meta-Body Anatomy
(4, 2, '2024-07-24');  -- Barry Mealive enrolls in Chemistry 101

-- BONUS: Ida Student enrolls in English And Its Derivatives
INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(5, 4, '2024-09-01');


-- Confirmation query for enrollments
SELECT 
    e.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    e.course_id,
    c.course_name,
    e.enrollment_date
FROM 
    enrollments e
JOIN 
    students s ON e.student_id = s.id
JOIN 
    courses c ON e.course_id = c.id;