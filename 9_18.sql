-- 9_1
INSERT INTO Disciplines (name_discipline) VALUES ('Искусство БДСМ');
INSERT INTO Disciplines (name_discipline) VALUES ('Аналгем');
INSERT INTO Disciplines (name_discipline) VALUES ('ООП');
INSERT INTO Disciplines (name_discipline) VALUES ('Базы данных');
INSERT INTO Disciplines (name_discipline) VALUES ('Мобильная разработка');
INSERT INTO Disciplines (name_discipline) VALUES ('Исскуственный интелект и большие данные');

-- 9_2 Дисциплины
DELETE FROM Disciplines WHERE name_discipline = 'Искусство БДСМ';
DELETE FROM Disciplines WHERE name_discipline = 'Аналгем';

--9_3 Специализации
INSERT INTO Specializations (name_specialization) VALUES ('ШЭМ');
INSERT INTO Specializations (name_specialization) VALUES ('ИМКТ');
INSERT INTO Specializations (name_specialization) VALUES ('ВШЭ');
INSERT INTO Specializations (name_specialization) VALUES ('ПИ');
INSERT INTO Specializations (name_specialization) VALUES ('ПИУ');

--9_4 Специализации
DELETE FROM Specializations WHERE name_specialization = 'ПИУ';

-- 9_5 Преподы
INSERT INTO Teachers (full_name, sex, birth_day, academic_degree) VALUES ('Диденко Михаил Петрович','M','1990-02-03','Научный руководитель');
INSERT INTO Teachers (full_name, sex, birth_day, academic_degree) VALUES ('Иван Иванович Иванов','M','1960-04-31','Кондидат наук');

--9_6 Преподы
DELETE FROM Teachers WHERE (full_name, sex, birth_day, academic_degree)= ('Иван Иванович Иванов','M','1960-04-31','Кондидат наук');

--9_7 Студенты
INSERT INTO Students (full_name, sex, birth_date, certificate_number) VALUES ('Иван Иванович Иванов','M','2002-11-09','123АERVD93D');
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
    SELECT Sex, COUNT(*) AS number_students_teachers
    FROM Students
    WHERE birth_date BETWEEN DATE(DATE('now'), '-22 years') AND DATE(DATE('now'), '-18 years')
    GROUP BY Sex
)

SELECT sex, SUM(number_students_teachers)
FROM over_people
GROUP BY Sex;

--12
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

--13
SELECT group_id, teacher_id
FROM Subjects
WHERE year_semester = '2022_1'
ORDER BY group_id;

--14
SELECT DISTINCT S.full_name
FROM Students S
         JOIN Activity A ON S.id = A.student_id
         JOIN Groups G ON G.id = A.group_id
WHERE G.group_number = 'СЦТ-18'
  AND A.time_of_entrance BETWEEN DATE('2002-01-01') AND DATE('2023-01-01');

--15_1
WITH group_number_action AS (
    SELECT DISTINCT G.ID AS GroupID
    FROM Students S
             JOIN Activity A ON S.ID = A.student_id
             JOIN Groups G ON G.ID = A.group_id
    WHERE S.full_name = 'Иван Иванович Иванов'
      AND A.time_of_entrance BETWEEN DATE('2002-11-09') AND DATE('2023-01-01')
      AND A.time_of_deduction IS NOT NULL
)
SELECT S.full_name
FROM group_number_action G
         JOIN Activity A ON G.GroupID = A.group_id
         JOIN Students S ON S.ID = A.student_id;

--16
INSERT INTO Grades (student_id, student_id, grade) VALUES (1, 3, 2);
INSERT INTO Grades (student_id, student_id, grade)  VALUES (2, 5, 2);
INSERT INTO Grades (student_id, student_id, grade) VALUES (4, 4, 2);

--17
SELECT S.full_name, G.subject_id, G.grade
FROM Students S
         JOIN Grades G ON S.id = G.student_id
         JOIN Activity A ON A.student_id = S.ID
         LEFT JOIN Subjects s ON s.id = G.subject_id
WHERE S.full_name = 'Иван Иванович Иванов';

--18
SELECT Subjects.group_id, Subjects.discipline_id, AVG(Grades.grade) AS average_grade
FROM Grades
         JOIN Subjects ON Grades.subject_id = Subjects.id
WHERE Subjects.discipline_id = 2
GROUP BY Subjects.group_id, Subjects.discipline_id;

