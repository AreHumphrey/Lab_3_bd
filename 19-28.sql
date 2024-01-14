--19
CREATE TRIGGER preventGroupDeletion
    BEFORE DELETE ON Groups
    FOR EACH ROW
    WHEN EXISTS (SELECT * FROM Activity WHERE Activity.group_id = OLD.id)
BEGIN
    SELECT RAISE(ABORT, 'Не допускается удаление групп, в которых числятся/числились какие-либо студенты');
END;

--Тест
INSERT INTO Groups (specialization_id, group_number, course) VALUES (5, 'СЦТ-21', 3);
DELETE FROM Groups WHERE ID = 3;
SELECT * from Groups;
DELETE FROM Groups WHERE ID = 2;

--20
CREATE TRIGGER prevent_Specialization_Deletion
    BEFORE DELETE ON Specializations
    FOR EACH ROW
    WHEN EXISTS (SELECT Activity.time_of_entrance FROM Groups JOIN Activity ON Activity.group_id = Groups.id WHERE specialization_id = OLD.id and Activity.time_of_entrance IS NOT NULL)
BEGIN
    SELECT RAISE(ABORT, 'Не допускается удаление специализаций, по которым были собранны непустые группы');
END;

INSERT INTO Groups (specialization_id, group_number, course) VALUES (5, 'TH-21', 2);
DELETE FROM Specializations WHERE id = 5;
SELECT * from Specializations;
DELETE FROM Specializations WHERE id = 2;

--21
CREATE TRIGGER deleteSpecializationNoGroups
    AFTER DELETE ON Groups
    FOR EACH ROW
    WHEN NOT EXISTS (SELECT * FROM Groups WHERE specialization_id = OLD.specialization_id)
BEGIN
    DELETE FROM Specializations WHERE id = OLD.specialization_id;
END;

--Тест
INSERT INTO Groups (Specialization_ID,  group_number, course) VALUES (5, 'TH-21', 2);
INSERT INTO Specializations (name_specialization) VALUES ('ШЭМ');
DELETE FROM Groups WHERE ID > 4;

--22
CREATE TRIGGER preventDisciplineDeletion
    BEFORE DELETE ON Disciplines
    FOR EACH ROW
    WHEN EXISTS (SELECT * FROM Subjects WHERE discipline_id = OLD.id)
BEGIN
    SELECT RAISE(ABORT, 'Не допускается удаление дисциплин, связанных с существующими предметами');
END;

--Тест
DELETE FROM Disciplines WHERE id = 4;
SELECT * FROM Disciplines;

DELETE FROM Disciplines WHERE id = 2;

--23
CREATE TRIGGER preventDuplicateTeachers
    BEFORE INSERT ON Subjects
    WHEN EXISTS (
        SELECT *
        FROM Subjects
        WHERE NEW.group_id = group_id
          AND NEW.year_semester = year_semester
          AND NEW.discipline_id = discipline_id
          AND NEW.teacher_id <> teacher_id
    )
BEGIN
    SELECT RAISE(ABORT, 'Нельзя назначить разным преподавателям одинаковые дисциплины в одной и той же группе');
END;

--Тест
INSERT INTO Subjects (group_id, discipline_id, year_semester, grade_type, teacher_id) VALUES (1, 1, '2023_1', 'Экзамен', 4);
SELECT * FROM Subjects;


INSERT INTO Subjects (group_id, discipline_id, year_semester, grade_type, teacher_id) VALUES (1, 1, '2023_1', 'Экзамен', 3);

--24
CREATE TRIGGER preventDuplicateStudents
    BEFORE INSERT ON Activity
    WHEN EXISTS (
        SELECT *
        FROM Activity
        WHERE NEW.Student_ID = student_id
          AND NEW.time_of_entrance IS NULL
          AND NEW.time_of_deduction IS NULL
    )
BEGIN
    SELECT RAISE(ABORT, 'Один студент не может числиться одновременно в разных группах.');
END;

--Тест

SELECT * FROM Activity;
INSERT INTO Activity (student_id, group_id, time_of_entrance) VALUES (1, 2, '2022-09-01');
SELECT * FROM Activity;
INSERT INTO Activity (student_id, group_id, time_of_deduction) VALUES (1, 1, '2022-09-01');
INSERT INTO Activity (student_id, group_id, time_of_deduction) VALUES (1, 2, '2022-09-01');

--25
CREATE TRIGGER updateGroupOnExpulsion
    BEFORE INSERT ON Activity
BEGIN
    UPDATE Activity
    SET time_of_entrance = DATETIME('now')
    WHERE student_id = NEW.student_id AND time_of_entrance IS NULL AND ID <> NEW.id;
END;

--Тест
INSERT INTO Activity (student_id, group_id, time_of_entrance) VALUES (3, 2, '2022-09-01');
SELECT * FROM Activity;
INSERT INTO Activity (student_id, group_id, time_of_entrance) VALUES (3, 1, '2023-09-01');
SELECT * FROM Activity;

--26
CREATE TRIGGER preventGradeWithoutGroup
    BEFORE INSERT ON Grades
    WHEN NOT EXISTS (
        SELECT *
        FROM Activity
                 JOIN Subjects ON Activity.group_id = Subjects.group_id
        WHERE Activity.student_id = NEW.student_id
          AND Subjects.id = NEW.subject_id
          AND Activity.time_of_entrance IS NULL
    )
BEGIN
    SELECT RAISE(ABORT, 'Не допускается проставление оценки студенту, если на данный момент времени он не числится в группе, связанной с соответствующим предметом');
END;

--Тест
INSERT INTO Grades (student_id, subject_id, grade) VALUES (1, 1, 5);

SELECT * FROM Activity;
SELECT * FROM Grades;
SELECT * FROM Subjects;

INSERT INTO Grades (student_id, subject_id, grade) VALUES (1, 2, 5);

--27
CREATE TRIGGER deletePreviousGrades
    AFTER INSERT ON Grades
BEGIN
    DELETE FROM Grades
    WHERE student_id = NEW.student_id
      AND subject_id = NEW.subject_id
      AND (ROWID != NEW.ROWID OR ROWID IS NULL);
END;

--Тест
INSERT INTO Grades (student_id, subject_id, grade) VALUES (1, 1, 2);
INSERT INTO Grades (student_id, subject_id, grade) VALUES (1, 2, 3);
SELECT * FROM Grades;
INSERT INTO Grades (student_id, subject_id, grade) VALUES (2, 2, 5);
SELECT * FROM Grades;
INSERT INTO Grades (student_id, subject_id, grade) VALUES (2, 2, 4);
SELECT * FROM Grades;

--28
CREATE TRIGGER preventPastGradeTime
    BEFORE INSERT ON Grades
    FOR EACH ROW
BEGIN
    SELECT
        CASE
            WHEN NEW.data > DATETIME('now') THEN
                RAISE (ABORT, '28.	Не допускается проставление оценки передним числом')
            END;
END;

--Тесты
INSERT INTO Grades (student_id, subject_id, grade, data) VALUES (1, 1, 5, '2022-09-01');
SELECT * FROM Grades;


INSERT INTO Grades (student_id, subject_id, grade, data) VALUES (1, 1, 5, '2024-09-01');