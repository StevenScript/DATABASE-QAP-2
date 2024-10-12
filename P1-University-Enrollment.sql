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
--    ADD INFORMATION TO SCRIPT       --
----------------------------------------