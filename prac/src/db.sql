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