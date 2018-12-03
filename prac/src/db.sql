CREATE DATABASE journal;

USE journal;

CREATE TABLE IF NOT EXISTS teacher
(
  id          INT         NOT NULL AUTO_INCREMENT,
  `lastname`  VARCHAR(45) NOT NULL,
  `firstname` VARCHAR(45) NOT NULL,
  `midname`   VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS faculty
(
  id     INT         NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS speciality
(
  id     INT         NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `group`
(
  id          INT         NOT NULL AUTO_INCREMENT,
  `groupName` VARCHAR(45) NOT NULL,
  `semester`  INT         NOT NULL,
  `course`    INT         NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS student
(
  id          INT         NOT NULL,
  `lastname`  VARCHAR(45) NOT NULL,
  `firstname` VARCHAR(45) NOT NULL,
  `midname`   VARCHAR(45) NOT NULL,
  `address`   VARCHAR(45) NOT NULL,
  `birthDate` DATE        NOT NULL,
  `entryDate` DATE        NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS class_type
(
  id INT         NOT NULL AUTO_INCREMENT,
  `type_name`    VARCHAR(45) NOT NULL,
  `hours_number` INT         NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS subject
(
  id     INT         NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS class
(
  id      INT         NOT NULL AUTO_INCREMENT,
  `date`  DATE        NOT NULL,
  `topic` VARCHAR(45) NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS phone
(
  id         INT         NOT NULL AUTO_INCREMENT,
  `number`   VARCHAR(12) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS group_has_type_subject_teacher
(
  class_type_id  INT NOT NULL,
  group_id       INT NOT NULL,
  subject_id     INT NOT NULL,
  teacher_id     INT NOT NULL,
  `hours_number` INT NULL,

  PRIMARY KEY (class_type_id, group_id, subject_id),

  CONSTRAINT fk_group_has_type_has_subject_class_type
    FOREIGN KEY (class_type_id)
      REFERENCES class_type (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_group_has_type_has_subject_group
    FOREIGN KEY (group_id)
      REFERENCES `group` (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_group_has_type_has_subject_subject
    FOREIGN KEY (subject_id)
      REFERENCES subject (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_group_has_type_has_subject_teacher
    FOREIGN KEY (teacher_id)
      REFERENCES teacher (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);


 CREATE TABLE IF NOT EXISTS student_has_class
(
  student_id     INT     NOT NULL,
  `hasMissed`    TINYINT NOT NULL,
  `isRespectful` TINYINT NULL,
  class_id       INT     NOT NULL,

  PRIMARY KEY (student_id, class_id),

  CONSTRAINT fk_student_has_class_student
    FOREIGN KEY (student_id)
    REFERENCES journal.student (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT fk_student_has_class_class
    FOREIGN KEY (class_id)
    REFERENCES journal.`class` (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS faculty_has_speciality
(
  faculty_id    INT NOT NULL,
  speciality_id INT NOT NULL,
  PRIMARY KEY (faculty_id, speciality_id),

  CONSTRAINT fk_faculty_has_speciality_faculty
    FOREIGN KEY (faculty_id)
      REFERENCES journal.faculty (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,

  CONSTRAINT fk_faculty_has_speciality_speciality
    FOREIGN KEY (speciality_id)
      REFERENCES journal.speciality (id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
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
