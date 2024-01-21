-- 9_1
INSERT INTO Disciplines (name_discipline) VALUES ('Искусство');
INSERT INTO Disciplines (name_discipline) VALUES ('Аналгем');
INSERT INTO Disciplines (name_discipline) VALUES ('ООП');
INSERT INTO Disciplines (name_discipline) VALUES ('Базы данных');
INSERT INTO Disciplines (name_discipline) VALUES ('Мобильная разработка');
INSERT INTO Disciplines (name_discipline) VALUES ('Исскуственный интелект и большие данные');

-- 9_2 Дисциплины
DELETE FROM Disciplines WHERE name_discipline = 'Искусство';
DELETE FROM Disciplines WHERE name_discipline = 'Аналгем';

--9_3 Специализации
INSERT INTO Specializations (name_specialization) VALUES ('ШЭМ');
INSERT INTO Specializations (name_specialization) VALUES ('ИМКТ');
INSERT INTO Specializations (name_specialization) VALUES ('ВШЭ');
INSERT INTO Specializations (name_specialization) VALUES ('ПИ');
INSERT INTO Specializations (name_specialization) VALUES ('ПИУ');

--9_4 Специализации
DELETE FROM Specializations WHERE name_specialization = 'ПИУ';

INSERT INTO Groups (specialization_id, group_number, course) VALUES (4, 'ТН-22', 2);

INSERT INTO Grades (student_id, subject_id, grade) VALUES (1, 1, 5);

INSERT INTO Subjects (group_id, discipline_id, year_semester, grade_type, teacher_id) VALUES (2, 1, '2023_1', 'Экзамен', 2);

-- 9_5 Преподы
INSERT INTO Teachers (full_name, sex, birth_day, academic_degree) VALUES ('8 8 7','M','1990-02-03','Научный руководитель');
INSERT INTO Teachers (full_name, sex, birth_day, academic_degree) VALUES ('Иван Иванович Иванов','M','1998-04-31','Кондидат наук');


--9_6 Преподы
DELETE FROM Teachers WHERE (full_name, sex, birth_day, academic_degree)= ('Иван Иванович Иванов','M','1960-04-31','Кондидат наук');

--9_7 Студенты
INSERT INTO Students (full_name, sex, birth_date, certificate_number) VALUES ('Иван Иванович Ивановd','M','2002-11-09','123АERVD93D');
INSERT INTO Students (full_name, sex, birth_date, certificate_number) VALUES ('Петрович Петр Игнатович','M','2011-09-09','234АERVD93D');
INSERT INTO Students (full_name, sex, birth_date,certificate_number) VALUES ('Пшенник Вячеслав Романович','M','2023-01-11','555АERVD93D');

DELETE FROM Students WHERE (full_name, sex, birth_date, certificate_number) = ('Петрович Петр Игнатович','M','2011-09-09','234АERVD93D');

--10
SELECT * from Activity WHERE time_of_deduction IS NOT NULL;
SELECT * FROM Activity WHERE time_of_entrance >= '2002-09-01';
SELECT * FROM Activity WHERE time_of_deduction > '2024-01-14';
SELECT * FROM Activity WHERE Student_ID = 1;

--11_1

SELECT sex, COUNT(*) AS number_of_teachers
FROM Teachers
WHERE birth_day BETWEEN DATE(DATE('now'), '-80 years') AND DATE(DATE('now'), '-19 years')
GROUP BY sex;

--11_2

SELECT sex, COUNT(*) AS number_of_students
FROM Students
WHERE birth_date BETWEEN DATE(DATE('now'), '-22 years') AND DATE(DATE('now'), '-18 years')
GROUP BY sex;

--11_3

WITH over_people AS (
    SELECT sex, COUNT(*) AS number_students_teachers
    FROM Teachers
    WHERE birth_day BETWEEN DATE(DATE('now'), '-80 years') AND DATE(DATE('now'), '-19 years')
    GROUP BY sex
    UNION ALL
    SELECT sex, COUNT(*) AS number_students_teachers
    FROM Students
    WHERE birth_date BETWEEN DATE(DATE('now'), '-22 years') AND DATE(DATE('now'), '-18 years')
    GROUP BY sex
)

SELECT sex, SUM(number_students_teachers)
FROM over_people
GROUP BY sex;

--12 (количество)
WITH over_people AS (
    SELECT sex, COUNT(*) AS number_students_teachers
    FROM Teachers
    WHERE birth_day BETWEEN DATE('1980-01-01') AND DATE('2004-01-01')
    GROUP BY sex
    UNION ALL
    SELECT sex, COUNT(*) AS number_students_teachers
    FROM Students
    WHERE birth_date BETWEEN DATE('2002-01-01') AND DATE('2004-01-01')
    GROUP BY sex
)
SELECT sex, SUM(number_students_teachers)
FROM over_people
GROUP BY sex;

--12 (данные)
WITH teachers_students AS (
    SELECT 'Teacher' AS person_type, id, full_name, sex, birth_day, academic_degree, NULL as certificate_number
    FROM Teachers
    WHERE birth_day BETWEEN DATE('1980-01-01') AND DATE('2004-01-01')

    UNION ALL

    SELECT 'Student' AS person_type, id, full_name, sex, birth_date, NULL as academic_degree, certificate_number
    FROM Students
    WHERE birth_date BETWEEN DATE('2002-01-01') AND DATE('2004-01-01')
)
SELECT *
FROM teachers_students;


--13

INSERT INTO Teachers (full_name, sex, birth_day, academic_degree)
VALUES
    ('АВАПРО ИПРОЛ', 'M', '1975-03-18', 'ЛОХ'),
    ('РРО РПМАПРО', 'F', '1980-07-22', 'ЛОР.');

INSERT INTO Groups (specialization_id, group_number, course)
VALUES
    (1, 'G101', 1),
    (2, 'G201', 2);

INSERT INTO Activity (student_id, group_id, time_of_entrance)
VALUES
    (1, 2, '2022-09-01');

INSERT INTO Subjects (group_id, discipline_id, year_semester, grade_type, teacher_id)
VALUES
    (2, 1, '2022_2', 'Экзамен', 1),
    (2, 2, '2022_2', 'Зачет', 2);

SELECT S.group_id, T.full_name AS teacher_name
FROM Subjects S
         JOIN Teachers T ON S.teacher_id = T.id
WHERE S.year_semester = '2022_2'
ORDER BY S.group_id;


--14
SELECT DISTINCT S.full_name
FROM Students S
         JOIN Activity A ON S.id = A.student_id
         JOIN Groups G ON G.id = A.group_id
WHERE G.group_number = 'ТН-22'
  AND A.time_of_entrance BETWEEN DATE('2002-01-01') AND DATE('2023-01-01');


--15
WITH group_number_action AS (
    SELECT DISTINCT G.ID AS GroupID
    FROM Students S
             JOIN Activity A ON S.ID = A.student_id
             JOIN Groups G ON G.ID = A.group_id
    WHERE S.ID = 8
      AND A.time_of_entrance BETWEEN DATE('2002-11-09') AND DATE('2023-01-01')
      AND A.time_of_deduction IS NOT NULL
)
SELECT S.full_name
FROM group_number_action G
         JOIN Activity A ON G.GroupID = A.group_id
         JOIN Students S ON S.ID = A.student_id
WHERE S.ID = 8;

INSERT INTO Groups (ID, specialization_id, group_number, course)
VALUES (12, 1, 'GroupA', 1);

INSERT INTO Students (ID, full_name, sex, birth_date, certificate_number)
VALUES (8, 'Боров О', 'M', '2000-01-01', 12345);

INSERT INTO Activity (student_id, group_id, time_of_entrance, time_of_deduction)
VALUES (8, 1, '2002-12-01', '2023-01-01');


--16
INSERT INTO Grades (student_id, student_id, grade) VALUES (1, 3, 2);
INSERT INTO Grades (student_id, student_id, grade)  VALUES (2, 5, 2);
INSERT INTO Grades (student_id, student_id, grade) VALUES (4, 4, 2);

--17
SELECT S.full_name, G.subject_id, G.grade
FROM Students S
         JOIN Grades G ON S.id = G.student_id
         JOIN Activity A ON A.student_id = S.id
         LEFT JOIN Subjects sub ON sub.id = G.subject_id
WHERE S.full_name = 'Иван Иванович Иванов';


--18
SELECT Subjects.group_id, Subjects.discipline_id, AVG(Grades.grade) AS average_grade
FROM Grades
         JOIN Subjects ON Grades.subject_id = Subjects.id
WHERE Subjects.discipline_id = 1
GROUP BY Subjects.group_id, Subjects.discipline_id;

