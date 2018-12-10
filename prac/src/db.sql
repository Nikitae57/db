#CREATE DATABASE journal;

USE journal;

CREATE TABLE IF NOT EXISTS teacher
(
  id        INT         NOT NULL AUTO_INCREMENT,
  lastname  VARCHAR(45) NOT NULL,
  firstname VARCHAR(45) NOT NULL,
  midname   VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS faculty
(
  id     INT         AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS speciality
(
  id     INT         NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `group`
(
  id          INT         NOT NULL AUTO_INCREMENT,
  groupName VARCHAR(45) NOT NULL,
  semester  INT         NOT NULL,
  course    INT         NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS student
(
  id          INT         NOT NULL,
  lastname  VARCHAR(45) NOT NULL,
  firstname VARCHAR(45) NOT NULL,
  midname   VARCHAR(45) NOT NULL,
  address   VARCHAR(45) NOT NULL,
  birthDate DATE        NOT NULL,
  entryDate DATE        NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS class_type
(
  id INT         NOT NULL AUTO_INCREMENT,
  type_name    VARCHAR(45) NOT NULL,
  hours_number INT         NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS subject
(
  id   INT         NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS class
(
  id    INT         NOT NULL AUTO_INCREMENT,
  date  DATE        NOT NULL,
  topic VARCHAR(45) NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS phone
(
  id         INT         NOT NULL AUTO_INCREMENT,
  number   VARCHAR(12) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS group_has_type_subject_teacher
(
  class_type_id  INT NOT NULL,
  group_id       INT NOT NULL,
  subject_id     INT NOT NULL,
  teacher_id     INT NOT NULL,
  hours_number INT NULL,

  PRIMARY KEY (class_type_id, group_id, subject_id),

  CONSTRAINT fk_group_has_type_subject_class_type
    FOREIGN KEY (class_type_id)
      REFERENCES journal.class_type (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_group_has_type_subject_group
    FOREIGN KEY (group_id)
      REFERENCES journal.`group` (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_group_has_type_subject_subject
    FOREIGN KEY (subject_id)
      REFERENCES journal.subject (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_group_has_type_has_subject_teacher
    FOREIGN KEY (teacher_id)
      REFERENCES journal.teacher (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);


 CREATE TABLE IF NOT EXISTS student_has_class
(
  student_id     INT     NOT NULL,
  hasMissed    TINYINT NOT NULL,
  isRespectful TINYINT NULL,
  class_id       INT     NOT NULL,

  CONSTRAINT fk_student_has_class_student
    FOREIGN KEY (student_id)
    REFERENCES journal.student (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT fk_student_has_class_class
    FOREIGN KEY (class_id)
    REFERENCES journal.class (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  PRIMARY KEY (student_id, class_id)
);


CREATE TABLE IF NOT EXISTS faculty_has_speciality
(
  faculty_id    INT NOT NULL,
  speciality_id INT NOT NULL,

  CONSTRAINT fk_faculty_has_speciality_faculty
    FOREIGN KEY (faculty_id)
      REFERENCES journal.faculty (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_faculty_has_speciality_speciality
    FOREIGN KEY (speciality_id)
      REFERENCES journal.speciality (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  PRIMARY KEY (faculty_id, speciality_id)
);

ALTER TABLE student
  ADD COLUMN group_id INT NOT NULL,

  ADD CONSTRAINT fk_student_group
    FOREIGN KEY (group_id)
      REFERENCES `group` (id)
      ON UPDATE NO ACTION
      ON DELETE NO ACTION;

ALTER TABLE `group`
  ADD COLUMN teacher_id                           INT,
  ADD COLUMN student_id                           INT,
  ADD COLUMN faculty_has_speciality_faculty_id    INT NOT NULL,
  ADD COLUMN faculty_has_speciality_speciality_id INT NOT NULL,

  ADD CONSTRAINT fk_group_teacher
    FOREIGN KEY (teacher_id)
      REFERENCES journal.teacher (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  ADD CONSTRAINT fk_group_student
    FOREIGN KEY (student_id)
      REFERENCES journal.student (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  ADD CONSTRAINT fk_group_speciality_faculty
    FOREIGN KEY (faculty_has_speciality_faculty_id,
                 faculty_has_speciality_speciality_id)
      REFERENCES faculty_has_speciality (faculty_id, speciality_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION;

ALTER TABLE phone
  ADD COLUMN student_id INT NOT NULL ,

  ADD CONSTRAINT fk_phone_student
    FOREIGN KEY (student_id)
      REFERENCES journal.student (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION;

ALTER TABLE class
  ADD COLUMN group_has_type_subject_teacher_group_id      INT NOT NULL,
  ADD COLUMN group_has_type_subject_teacher_class_type_id INT NOT NULL,
  ADD COLUMN group_has_type_subject_teacher_subject_id    INT NOT NULL,

  ADD CONSTRAINT fk_class_group_has_type_subject_teacher
    FOREIGN KEY (group_has_type_subject_teacher_group_id,
                 group_has_type_subject_teacher_class_type_id,
                 group_has_type_subject_teacher_subject_id)
      REFERENCES journal.group_has_type_subject_teacher (group_id,
                                                         class_type_id,
                                                         subject_id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION;

INSERT faculty (name)
VALUES ('ИПАИТ'),
       ('ИЕНИБ');

INSERT speciality (name)
VALUES ('Программная инженерия'),
       ('Биология'),
       ('Прикладная информатика');

INSERT faculty_has_speciality (faculty_id, speciality_id)
VALUES ((SELECT id FROM faculty WHERE name = 'ИПАИТ' LIMIT 1),
        (SELECT id FROM speciality WHERE name = 'Программная инженерия' LIMIT 1));

INSERT faculty_has_speciality (faculty_id, speciality_id)
VALUES ((SELECT id FROM faculty WHERE name = 'ИПАИТ' LIMIT 1),
        (SELECT id FROM speciality WHERE name = 'Прикладная информатика' LIMIT 1));

INSERT faculty_has_speciality (faculty_id, speciality_id)
VALUES ((SELECT id FROM faculty WHERE name = 'ИЕНИБ' LIMIT 1),
        (SELECT id FROM speciality WHERE name = 'Биология' LIMIT 1));

INSERT `group` (faculty_has_speciality_speciality_id, faculty_has_speciality_faculty_id, groupName, semester, course)
VALUES ((SELECT id FROM speciality WHERE name = 'Программная инженерия' LIMIT 1),
        (SELECT id FROM faculty WHERE name = 'ИПАИТ' LIMIT 1),
        '71-ПГ',
        3,
        2),

       ((SELECT id FROM speciality WHERE name = 'Прикладная информатика' LIMIT 1),
        (SELECT id FROM faculty WHERE name = 'ИПАИТ' LIMIT 1),
        '71-ПИ',
        3,
        2),

       ((SELECT id FROM speciality WHERE name = 'Биология' LIMIT 1),
        (SELECT id FROM faculty WHERE name = 'ИЕНИБ' LIMIT 1),
        '71-Б',
        3,
        2);

INSERT teacher (lastname, firstname, midname)
VALUES ('Рыженков', 'Денис', 'Викторович'),
       ('Волков', 'Вадим', 'Николаевич'),
       ('Харламов', 'Владимир', 'Федорович'),
       ('Фроленкова', 'Лариса', 'Юрьевна');

INSERT subject (name)
VALUES ('Базы данных'),
       ('Биология'),
       ('Физика');

INSERT student (id, lastname, firstname, midname, address, birthDate, entryDate, group_id)
VALUES (170576,
        'Евдокимов',
        'Никита',
        'Александрович',
        'г. Орёл, ул. Московское шоссе, 113б',
        '1999-08-26',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПГ')),

       (170586,
        'Панин',
        'Михаил',
        'Сергеевич',
        'г. Орёл, ул. Московское шоссе, 113а',
        '1999-03-23',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПГ')),

       (170572,
        'Щекотихин',
        'Сергей',
        'Батькович',
        'г. Туринская Слобода, ул. Московская, дом 76',
        '1999-12-12',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПГ')),

       (170554,
        'Короткий',
        'Александр',
        'Иосифович',
        'г. Рубцовск, ул. Батинская, дом 58',
        '1999-04-04',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПГ')),

       (170514,
        'Кожухова',
        'Ольга',
        'Влдаимировна',
        'г. Барыш, ул. Бабаевская улица, дом 96',
        '1999-02-02',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПГ')),

       (170214,
        'Григорьев',
        'Михаил',
        'Николаевич',
        'г. Нелидово, ул. Вагонников 1-я, дом 72',
        '1974-06-01',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПИ')),

       (170265,
        'Кудрявцев',
        'Светозар',
        'Сергеевич',
        'г. Заречье, ул. Завокзальная 1-я, дом 5',
        '1970-08-12',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПИ')),

       (170123,
        'Виноградов',
        'Глеб',
        'Евгеньевич',
        'г. Онгудай, ул. Строителей, дом 41',
        '1986-09-17',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПИ')),

       (170122,
        'Сысолятина',
        'Антонида',
        'Владиславовна',
        'г. Верхневилюйск, ул. Беговая 4-я, дом 4',
        '1973-09-10',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПИ')),

       (170222,
        'Киселёва',
        'Злата',
        'Федоровна',
        'г. Красная Горбатка, ул. Веселова, дом 27',
        '1976-06-18',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-ПИ')),

       (170224,
        'Городнова',
        'Лиана',
        'Богдановна',
        'г. Маркс, ул. Батайская, дом 10',
        '1985-06-11',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-Б')),

       (170784,
        'Перкосрака',
        'Даздраперма',
        'Иосивна',
        'г. Суздаль, ул. Достоевского, дом 94',
        '1992-10-04',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-Б')),

       (170124,
        'Будигост',
        'Борщ',
        'Малевич',
        'г. Тишино, ул. Весенняя, дом 83',
        '1975-04-20',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-Б')),

       (170524,
        'Здиславин',
        'Жирослав',
        'Коземирович',
        'г. Чернышковский, ул. Вагжанова, дом 86',
        '1977-006-04',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-Б')),

       (170573,
        'Трифонова',
        'Аграфена',
        'Сергеевна',
        ' г. Брянское, ул. Садовая, дом 16',
        '1967-09-16',
        '2017-09-01',
        (SELECT id FROM `group` WHERE groupName = '71-Б'));

INSERT phone (student_id, number)
VALUES (170573, 88005553535),
       (170265, 88005553536),
       (170122, 88005553537),
       (170214, 88005553538),
       (170124, 88005553539),
       (170222, 88005553540),
       (170524, 88005553541),
       (170224, 88005553542),
       (170123, 88005553543),
       (170784, 88005553544),
       (170514, 88005553545),
       (170586, 88005553546),
       (170554, 88005553547),
       (170576, 88005553548),
       (170572, 88005553549),
       (170124, 88005553550),
       (170123, 88005553551);

INSERT class_type (type_name, hours_number)
VALUES ('Лабораторная работа', 2),
       ('Практическая работа', 1),
       ('Лекция', 1);

# Added
INSERT group_has_type_subject_teacher (class_type_id, group_id, subject_id, teacher_id, hours_number)
VALUES
((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПГ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Рыженков'
    AND teacher.firstname = 'Денис'
    AND teacher.midname = 'Викторович'
  LIMIT 1),
 14
),

(
 (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПГ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Волков'
    AND teacher.firstname = 'Вадим'
    AND teacher.midname = 'Николаевич'
  LIMIT 1),
 20
 ),

(
 (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПГ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Рыженков'
    AND teacher.firstname = 'Денис'
    AND teacher.midname = 'Викторович'
  LIMIT 1),
 14
 );

# Added
INSERT group_has_type_subject_teacher (class_type_id, group_id, subject_id, teacher_id, hours_number)
VALUES
((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПГ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 14),

((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПГ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 12
);

# Added
INSERT group_has_type_subject_teacher (class_type_id, group_id, subject_id, teacher_id, hours_number)
VALUES
((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПИ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 16),

((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПИ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 10
);

# Added
INSERT group_has_type_subject_teacher (class_type_id, group_id, subject_id, teacher_id, hours_number)
VALUES
((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-Б' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 16),

((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-Б' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 8
),

((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-Б' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Харламов'
    AND teacher.firstname = 'Владимир'
    AND teacher.midname = 'Федорович'
  LIMIT 1),
 12
);

# Added
INSERT group_has_type_subject_teacher (class_type_id, group_id, subject_id, teacher_id, hours_number)
VALUES
((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-Б' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Биология' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Фроленкова'
    AND teacher.firstname = 'Лариса'
    AND teacher.midname = 'Юрьевна'
  LIMIT 1),
 20),

((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-Б' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Биология' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Фроленкова'
    AND teacher.firstname = 'Лариса'
    AND teacher.midname = 'Юрьевна'
  LIMIT 1),
 18
),

((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-Б' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Биология' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Фроленкова'
    AND teacher.firstname = 'Лариса'
    AND teacher.midname = 'Юрьевна'
  LIMIT 1),
 32
);

# Added
INSERT group_has_type_subject_teacher (class_type_id, group_id, subject_id, teacher_id, hours_number)
VALUES
((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПИ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Рыженков'
    AND teacher.firstname = 'Денис'
    AND teacher.midname = 'Викторович'
  LIMIT 1),
 24),

 ((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПИ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Рыженков'
    AND teacher.firstname = 'Денис'
    AND teacher.midname = 'Викторович'
  LIMIT 1),
 18),

 ((SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1),
 (SELECT `group`.id FROM `group` WHERE `group`.groupName = '71-ПИ' LIMIT 1),
 (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
 (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Волков'
    AND teacher.firstname = 'Вадим'
    AND teacher.midname = 'Николаевич'
  LIMIT 1),
 18);

INSERT class (date,
              topic,
              group_has_type_subject_teacher_group_id,
              group_has_type_subject_teacher_subject_id,
              group_has_type_subject_teacher_class_type_id)

VALUES ('2018-12-10',
        'Тема по биологии №1',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-Б'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Биология'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лекция')),

       ('2018-12-12',
        'Препарирование',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-Б'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Биология'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лабораторная работа')),

       ('2018-12-18',
        'Подсчет популяции белок в Орловской области',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-Б'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Биология' LIMIT 1),
        (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1));

INSERT class (date,
              topic,
              group_has_type_subject_teacher_group_id,
              group_has_type_subject_teacher_subject_id,
              group_has_type_subject_teacher_class_type_id)

VALUES ('2018-12-10',
        'Тема по физике №1',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПИ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лекция')),

       ('2018-12-18',
        'Протирание эбонитовых палочек',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПИ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
        (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1));

INSERT class (date,
              topic,
              group_has_type_subject_teacher_group_id,
              group_has_type_subject_teacher_subject_id,
              group_has_type_subject_teacher_class_type_id)

VALUES ('2018-12-10',
        'Тема по физике №1',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПГ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лекция')),

       ('2018-12-18',
        'Протирание эбонитовых палочек',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПГ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
        (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1));

INSERT class (date,
              topic,
              group_has_type_subject_teacher_group_id,
              group_has_type_subject_teacher_subject_id,
              group_has_type_subject_teacher_class_type_id)

VALUES ('2018-12-10',
        'Тема по физике №1',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-Б'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лекция')),

       ('2018-12-12',
        'Электропроводимость полупроводников',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-Б'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лабораторная работа')),

       ('2018-12-18',
        'Протирание эбонитовых палочек',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-Б'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Физика' LIMIT 1),
        (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Практическая работа' LIMIT 1));

INSERT class (date,
              topic,
              group_has_type_subject_teacher_group_id,
              group_has_type_subject_teacher_subject_id,
              group_has_type_subject_teacher_class_type_id)

VALUES ('2018-12-24',
        'Тема по базам данных №1',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПГ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лекция')),

       ('2018-12-25',
        NULL,
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПГ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных'),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лабораторная работа')),

       ('2018-12-26',
        NULL,
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПГ'),
        (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
        (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1));

INSERT class (date,
              topic,
              group_has_type_subject_teacher_group_id,
              group_has_type_subject_teacher_subject_id,
              group_has_type_subject_teacher_class_type_id)

VALUES ('2018-12-24',
        'Тема по базам данных №1',
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПИ' LIMIT 1),
        (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лекция' LIMIT 1)),

       ('2018-12-25',
        NULL,
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПИ' LIMIT 1),
        (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
        (SELECT id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1)),

       ('2018-12-26',
        NULL,
        (SELECT `group`.id FROM `group` WHERE groupName = '71-ПИ' LIMIT 1),
        (SELECT subject.id FROM subject WHERE subject.name = 'Базы данных' LIMIT 1),
        (SELECT class_type.id FROM class_type WHERE class_type.type_name = 'Лабораторная работа' LIMIT 1));

INSERT student_has_class (student_id, hasMissed, isRespectful, class_id)
VALUES ((SELECT id FROM student WHERE lastname = 'Евдокимов'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 1
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Панин'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 1
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Щекотихин'),
        1,
        1,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 1
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Кожухова'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 1
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Короткий'),
        1,
        1,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 1
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1));

INSERT student_has_class (student_id, hasMissed, isRespectful, class_id)
VALUES ((SELECT id FROM student WHERE lastname = 'Сысолятина'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 2
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Виноградов'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 2
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Григорьев'),
        1,
        1,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 2
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Киселёва'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 2
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1)),
       ((SELECT id FROM student WHERE lastname = 'Кудрявцев'),
        1,
        1,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 2
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 1));

INSERT student_has_class (student_id, hasMissed, isRespectful, class_id)
VALUES ((SELECT id FROM student WHERE lastname = 'Будигост'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 3
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 2)),
       ((SELECT id FROM student WHERE lastname = 'Городнова'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 3
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 2)),
       ((SELECT id FROM student WHERE lastname = 'Здиславин'),
        1,
        1,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 3
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 2)),
       ((SELECT id FROM student WHERE lastname = 'Трифонова'),
        0,
        NULL,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 3
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 2)),
       ((SELECT id FROM student WHERE lastname = 'Перкосрака'),
        1,
        1,
        (SELECT id FROM class WHERE class.group_has_type_subject_teacher_group_id = 3
                                AND class.group_has_type_subject_teacher_class_type_id = 3
                                AND class.group_has_type_subject_teacher_subject_id = 2));

UPDATE `group`
SET teacher_id = NULL
WHERE groupName = '71-ПГ';

UPDATE `group`
SET teacher_id = ((SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Рыженков'
    AND teacher.firstname = 'Денис'
    AND teacher.midname = 'Викторович'
  LIMIT 1))
WHERE groupName = '71-ПИ';

UPDATE `group`
SET teacher_id = (SELECT teacher.id
  FROM teacher
  WHERE teacher.lastname = 'Фроленкова'
    AND teacher.firstname = 'Лариса'
    AND teacher.midname = 'Юрьевна'
  LIMIT 1)
WHERE groupName = '71-Б';

UPDATE `group`
SET student_id = (SELECT id FROM student WHERE lastname = 'Кожухова')
WHERE groupName = '71-ПГ';

UPDATE `group`
SET student_id = (SELECT id FROM student WHERE lastname = 'Киселёва')
WHERE groupName = '71-ПИ';

UPDATE `group`
SET student_id = (SELECT id FROM student WHERE lastname = 'Перкосрака')
WHERE groupName = '71-Б';

CREATE TABLE table_for_drop (
  id INT NOT NULL AUTO_INCREMENT,
  field VARCHAR(10) NOT NULL,

  PRIMARY KEY (id)
);

DROP TABLE table_for_drop;

INSERT student
VALUES (123422,
        'Фамилия',
        'Имя',
        'Отчество',
        'г. Орел, ул. Кукушкина, д. Колотушкина',
        '1998-12-12',
        '2017-08-17',
        (SELECT id FROM `group` WHERE groupName ='71-ПГ'));

DELETE FROM student WHERE student.id = 123422;

SELECT * FROM `group`;

SELECT id, lastname, firstname, midname FROM student;

SELECT lastname, groupName FROM student, `group`;

SELECT lastname, name FROM teacher, subject;

SELECT lastname FROM student
  INNER JOIN `group`
    ON student.group_id = `group`.id
  WHERE groupName = '71-Б';

SELECT DISTINCT lastname, firstname, midname, name FROM teacher
  INNER JOIN group_has_type_subject_teacher
    ON teacher_id = teacher.id
  INNER JOIN subject
    ON group_has_type_subject_teacher.subject_id = subject.id;

SELECT COUNT(student.id), groupName FROM student
  INNER JOIN `group`
    ON `group`.id = student.group_id
  GROUP BY groupName;

SELECT MIN(birthDate), student.group_id FROM student
GROUP BY student.group_id;

SELECT lastname, firstname, midname FROM student
  INNER JOIN (SELECT id FROM `group` WHERE groupName = '71-ПГ') AS gr
    ON student.group_id = gr.id;

SELECT COUNT(hasMissed), `date` FROM class
  INNER JOIN (SELECT student_id, class_id, hasMissed FROM student_has_class) AS student_has_class
    ON student_has_class.class_id = class.id
  WHERE hasMissed = 1
  GROUP BY `date`;

CREATE TRIGGER trigger_student_name
  BEFORE INSERT
  ON student FOR EACH ROW
BEGIN
  IF NEW.firstname REGEXP '[А-Яа-я]' != '' THEN
    SET @firstname := NEW.firstname;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Только русские буквы';
  END IF;

  IF NEW.lastname REGEXP '[А-Яа-я]' != '' THEN
    SET @lastname := NEW.lastname;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Только русские буквы';
  END IF;

  IF NEW.midname REGEXP '[А-Яа-я]' != '' THEN
    SET @midname := NEW.midname;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Только русские буквы';
  END IF;
END;

CREATE TRIGGER trigger_student_birthdate_lower_than_entry_date
  BEFORE INSERT
  ON student FOR EACH ROW
BEGIN
  IF NEW.birthDate < NEW.entryDate THEN
    SET @birhdate = NEW.birthDate;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Родился позже, чем поступил?';
  END IF;
END;

CREATE TRIGGER trigger_teacher_name
  BEFORE INSERT
  ON teacher FOR EACH ROW
BEGIN
  IF NEW.firstname REGEXP '[А-Яа-я]' != '' THEN
    SET @firstname := NEW.firstname;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Только русские буквы';
  END IF;

  IF NEW.lastname REGEXP '[А-Яа-я]' != '' THEN
    SET @lastname := NEW.lastname;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Только русские буквы';
  END IF;

  IF NEW.midname REGEXP '[А-Яа-я]' != '' THEN
    SET @midname := NEW.midname;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Только русские буквы';
  END IF;
END;

CREATE TRIGGER trigger_student_has_class_belongs_to_group
  BEFORE INSERT
  ON student_has_class FOR EACH ROW
BEGIN
  DECLARE student_group_id INT;
  DECLARE class_group_id INT;

  SET student_group_id =
    (SELECT group_id FROM student WHERE student.id = NEW.student_id LIMIT 1);

  SET class_group_id =
      (SELECT class.group_has_type_subject_teacher_group_id FROM class WHERE class.id = NEW.class_id LIMIT 1);


  IF student_group_id = class_group_id THEN
    SET @student_id = NEW.student_id;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Студент не принадлежит этой группе';
  END IF;
END;

CREATE TRIGGER trigger_glav_student_belongs_to_group
  BEFORE UPDATE
  ON `group` FOR EACH ROW
BEGIN
  DECLARE student_group_id INT;

  SET student_group_id = (SELECT student.group_id FROM student WHERE student.id = NEW.student_id);

  IF student_group_id = id THEN
    SET @student_id = NEW.student_id;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Староста не из этой группы';
  END IF;
END;

CREATE TRIGGER trigger_glav_student_belongs_to_group_insert
  BEFORE UPDATE
  ON `group` FOR EACH ROW
BEGIN
  DECLARE student_group_id INT;

  SET student_group_id = (SELECT student.group_id FROM student WHERE student.id = NEW.student_id);

  IF student_group_id = id THEN
    SET @student_id = NEW.student_id;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Староста не из этой группы';
  END IF;
END;

CREATE TRIGGER trigger_phone_only_digits
  BEFORE INSERT
  ON phone FOR EACH ROW
BEGIN
  IF NEW.number REGEXP '^[0-9]+$' THEN
    SET @number = NEW.number;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Телефон может состоять только из цифр';
  END IF ;
END;

CREATE TRIGGER trigger_student_birthdate_lower_than_today
  BEFORE INSERT
  ON student FOR EACH ROW
BEGIN
  DECLARE curr_date DATE;
  SET curr_date = CURDATE();

  IF NEW.birthDate < curr_date THEN
    SET @birhdate = NEW.birthDate;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Родился позже, чем сегодня?';
  end if;
END;

CREATE TRIGGER trigger_student_entrydate_lower_than_today
  BEFORE INSERT
  ON student FOR EACH ROW
BEGIN
  DECLARE curr_date DATE;
  SET curr_date = CURDATE();

  IF NEW.entryDate < curr_date THEN
    SET @entryDate= NEW.entryDate;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Поступил позже, чем сегодня?';
  end if;
END;

CREATE TRIGGER num_hours_type_class_less_0
  BEFORE INSERT
  ON class_type FOR EACH ROW
BEGIN
  IF NEW.hours_number > 0 THEN
    SET @hours_number = NEW.hours_number;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кол-во часов должно быть больше 0';
  end if;
END;

CREATE TRIGGER num_hours_subject_less_0
  BEFORE INSERT
  ON group_has_type_subject_teacher FOR EACH ROW
BEGIN
  IF NEW.hours_number > 0 THEN
    SET @hours_number = NEW.hours_number;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кол-во часов должно быть больше 0';
  end if;
END;

CREATE TRIGGER num_course_and_semester_less_0
  BEFORE INSERT
  ON `group` FOR EACH ROW
BEGIN
  IF NEW.course > 0 THEN
    SET @course = NEW.course;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Курс группы должен быть больше 0';
  end if;

  IF NEW.semester > 0 THEN
    SET @semester = NEW.semester;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Семестр группы должен быть больше 0';
  end if;
END;

CREATE TRIGGER num_hours_type_class_less_0_update
  BEFORE UPDATE
  ON class_type FOR EACH ROW
BEGIN
  IF NEW.hours_number > 0 THEN
    SET @hours_number = NEW.hours_number;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кол-во часов должно быть больше 0';
  end if;
END;

CREATE TRIGGER num_hours_subject_less_0_update
  BEFORE UPDATE
  ON group_has_type_subject_teacher FOR EACH ROW
BEGIN
  IF NEW.hours_number > 0 THEN
    SET @hours_number = NEW.hours_number;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кол-во часов должно быть больше 0';
  end if;
END;

CREATE TRIGGER num_course_and_semester_less_0_update
  BEFORE UPDATE
  ON `group` FOR EACH ROW
BEGIN
  IF NEW.course > 0 THEN
    SET @course = NEW.course;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Курс группы должен быть больше 0';
  end if;

  IF NEW.semester > 0 THEN
    SET @semester = NEW.semester;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Семестр группы должен быть больше 0';
  end if;
END;

DELIMITER //
CREATE PROCEDURE nothing_in_nothing_out()
BEGIN
  SELECT * FROM student;
END//