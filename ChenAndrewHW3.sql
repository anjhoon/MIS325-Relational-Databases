-- Andrew Chen
-- MIS325 HW
-- ac68644

-- Part 1 --
-- Question 1 --
create table Student(
Student_ID NUMBER(7),
Student_Name VARCHAR(25) NOT NULL,
CONSTRAINT pk_Student PRIMARY KEY(Student_ID)
);

-- Question 2 --
create table Faculty(
Faculty_ID NUMBER(5),
Faculty_Name VARCHAR(25) NOT NULL,
CONSTRAINT pk_Faculty PRIMARY KEY(Faculty_ID)
);

-- Question 3 --
create table Course(
Course_ID VARCHAR(8),
Course_Name VARCHAR(50) NOT NULL,
CONSTRAINT pk_Course PRIMARY KEY(Course_ID)
);

-- Question 4 --
create table Is_Qualified(
Faculty_ID NUMBER(5),
Course_ID VARCHAR(8),
CONSTRAINT pk_Is_Qualified PRIMARY KEY(Faculty_ID, Course_ID),
CONSTRAINT fk_Faculty_ID_Qual FOREIGN KEY(Faculty_ID) REFERENCES Faculty(Faculty_ID),
CONSTRAINT fk_Course_ID_Qual FOREIGN KEY(Course_ID) REFERENCES Course(Course_ID)
);

-- Question 5 --
create table Is_Registered(
Student_ID NUMBER(7),
Course_ID VARCHAR(8),
Semester VARCHAR(9),
CalendarYear NUMBER(4) NOT NULL,
CONSTRAINT pk_Is_Registered PRIMARY KEY(Student_ID, Course_ID),
CONSTRAINT fk_Student_ID_Reg FOREIGN KEY(Student_ID) REFERENCES Student(Student_ID),
CONSTRAINT fk_Course_ID_Reg FOREIGN KEY(Course_ID) REFERENCES Course(Course_ID),
CONSTRAINT ck_Semester CHECK(Semester IN ('Summer', 'Fall', 'Winter', 'Spring'))
);

-- Part 2 --
-- Question 1 --
INSERT INTO Student VALUES(3452342,'Lisa Simpson');
INSERT INTO Student VALUES(2344567, 'Bart Simpson');

-- Question 2 --
INSERT INTO Faculty VALUES(44645,'John Banks');
INSERT INTO Faculty VALUES(85666, 'Jackie Smith');
INSERT INTO Faculty VALUES(38294, 'Chris Couch');

-- Question 3 --
INSERT INTO Course VALUES('MIS325', 'Database Management');
INSERT INTO Course VALUES('ACC362', 'Auditing and Control');
INSERT INTO Course VALUES('FIN377', 'Portfolio Analysis and Management');
INSERT INTO Course VALUES('MIS373', 'Data Mining for Business Intelligence');

-- Question 4 --
INSERT INTO Is_Qualified VALUES(44645, 'MIS325');
INSERT INTO Is_Qualified VALUES(85666, 'MIS325');
INSERT INTO Is_Qualified VALUES(38294, 'FIN377');

-- Question 5 --
INSERT INTO Is_Registered VALUES(3452342, 'MIS325', 'Summer', 2017);
INSERT INTO Is_Registered VALUES(3452342, 'FIN377', 'Fall', 2017);
INSERT INTO Is_Registered VALUES(2344567, 'MIS325', 'Spring', 2018);

-- Part 3 --
-- Question 1--
SELECT Course_ID, Course_Name
FROM Course
WHERE Course_ID LIKE 'MIS%';

-- Question 2 --
SELECT Faculty_ID
FROM Is_Qualified
WHERE Course_ID = 'MIS325';

-- Question 3 --
SELECT COUNT(Course_ID) AS Total_Number_Of_IS_Courses
FROM Course
WHERE Course_ID LIKE 'MIS%';

-- Question 4 --
SELECT Student_ID
FROM Is_Registered
WHERE Semester = 'Summer';

-- Question 5 --
SELECT COUNT(Student_ID) AS Total_Students_Taken_MIS325
FROM Is_Registered
WHERE Course_ID = 'MIS325';

-- Question 6 --
SELECT Student_ID
FROM Is_Registered
WHERE Course_ID = 'MIS325';

