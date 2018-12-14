#CREATE DATABASE cafe;

use cafe;

CREATE TABLE cafe
(
  id      INT NOT NULL AUTO_INCREMENT,
  address VARCHAR(200),

  PRIMARY KEY (id)
);


CREATE TABLE order_entry
(
  id     INT NOT NULL AUTO_INCREMENT,
  price  INT NOT NULL,
  amount INT NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE meal
(
  id        INT          NOT NULL AUTO_INCREMENT,
  name      VARCHAR(45)  NOT NULL,
  weight    INT          NOT NULL,
  price     INT          NOT NULL,
  image_uri VARCHAR(500) NOT NULL,
  calorie   INT          NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE `order`
(
  id         INT          NOT NULL AUTO_INCREMENT,
  price      INT          NOT NULL,
  order_time TIMESTAMP(6) NOT NULL,
  is_paid    TINYINT      NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE pay_method
(
  id   INT         NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE category
(
  id          INT         NOT NULL AUTO_INCREMENT,
  name        VARCHAR(45) NOT NULL,
  description VARCHAR(200) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE discount
(
  id          INT  NOT NULL AUTO_INCREMENT,
  start_time  DATE NOT NULL,
  finish_time DATE NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE discount_card
(
  id         INT         NOT NULL AUTO_INCREMENT,
  phone      VARCHAR(12) NOT NULL,
  lastname   VARCHAR(45),
  firstname  VARCHAR(45),
  midname    VARCHAR(45),
  email      VARCHAR(45),
  birth_date DATE,
  issue_date DATE NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE discount_card_type
(
  id              INT         NOT NULL AUTO_INCREMENT,
  name            VARCHAR(45) NOT NULL,
  discount_amount INT         NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE meal_has_category
(
  meal_id     INT NOT NULL,
  category_id INT NOT NULL,

  PRIMARY KEY (meal_id, category_id)
);

ALTER TABLE order_entry
  ADD COLUMN meal_id  INT NOT NULL,
  ADD COLUMN order_id INT NOT NULL,

  ADD CONSTRAINT fk_order_entry_meal
    FOREIGN KEY (meal_id) REFERENCES meal (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,

  ADD CONSTRAINT fk_order_entry_order
    FOREIGN KEY (order_id) REFERENCES `order` (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION;

ALTER TABLE discount_card
  ADD COLUMN discount_card_type_id INT NOT NULL,

  ADD CONSTRAINT fk_discount_card_discount_card_type_id
    FOREIGN KEY (discount_card_type_id) REFERENCES discount_card_type (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION;

ALTER TABLE meal_has_category
  ADD CONSTRAINT fk_meal_has_category_meal
    FOREIGN KEY (meal_id) REFERENCES meal (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,

  ADD CONSTRAINT fk_meal_has_category_category
    FOREIGN KEY (category_id) REFERENCES category (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION;

ALTER TABLE `order`
  ADD COLUMN pay_method_id    INT NOT NULL,
  ADD COLUMN cafe_id          INT NOT NULL,
  ADD COLUMN discount_id      INT,
  ADD COLUMN discount_card_id INT,

  ADD CONSTRAINT fk_order_pay_method
    FOREIGN KEY (pay_method_id) REFERENCES pay_method (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,

  ADD CONSTRAINT fk_order_cafe
    FOREIGN KEY (cafe_id) REFERENCES cafe (id)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,

  ADD CONSTRAINT fk_order_discount
    FOREIGN KEY (discount_id) REFERENCES discount (id)
      ON UPDATE CASCADE
      ON DELETE SET NULL,

  ADD CONSTRAINT fk_order_discount_card
    FOREIGN KEY (discount_card_id) REFERENCES discount_card (id)
      ON UPDATE CASCADE
      ON DELETE SET NULL;

INSERT cafe (address)
  VALUES ('Кафе №1'),
         ('Кафе №2');

INSERT meal (name, weight, price, image_uri, calorie)
VALUES ('Салат цезарь', 300, 200,
        'https://goo.gl/images/gSpVXX', 400),
       ('Сливочная маргарита', 500, 400,
        'https://goo.gl/images/29QTzS', 800),
       ('Латте с ванилью', 250, 150,
        'https://goo.gl/images/gkFsR5', 200),
       ('Шаурма со свининой', 290, 120,
        'https://goo.gl/images/Ze9YM2', 400),
       ('Картошка фри', 50, 60,
        'https://goo.gl/images/6HCtqN', 300),
       ('Яблочный сок', 250, 40,
        'https://goo.gl/images/DfuYdA', 50),
       ('Стафф с ветчиной', 500, 600,
        'https://goo.gl/images/jgnt9n', 1000),
       ('Сосиска в тесте', 100, 50,
        'https://goo.gl/images/tr4VVz', 300);

INSERT category (name, description)
VALUES ('Холодные блюда',
        'Подходят в нежаркий день'),
       ('Салаты',
        'Если вы следите за фигурой'),
       ('Напитки',
        'То, чем можно утолить жажду'),
       ('Горячие напитки',
        'Помогут согреться'),
       ('Холодные напитки',
        'помогут освежиться'),
       ('Пиццы',
        'Вариант на все случаи жихни'),
       ('Фаст фуд',
        'Вкусная еда почти всегда вредная. И это не исключение'),
       ('С собой',
        'То, что легко есть на ходу');

INSERT meal_has_category (meal_id, category_id)
VALUES ((SELECT id FROM meal WHERE name = 'Салат цезарь'),
        (SELECT id FROM category WHERE name = 'Холодные блюда')),
       ((SELECT id FROM meal WHERE name = 'Салат цезарь'),
        (SELECT id FROM category WHERE name = 'Салаты')),
       ((SELECT id FROM meal WHERE name = 'Сливочная маргарита'),
        (SELECT id FROM category WHERE name = 'Пиццы')),
       ((SELECT id FROM meal WHERE name = 'Латте с ванилью'),
        (SELECT id FROM category WHERE name = 'Напитки')),
       ((SELECT id FROM meal WHERE name = 'Латте с ванилью'),
        (SELECT id FROM category WHERE name = 'Горячие напитки')),
       ((SELECT id FROM meal WHERE name = 'Шаурма со свининой'),
        (SELECT id FROM category WHERE name = 'С собой')),
       ((SELECT id FROM meal WHERE name = 'Картошка фри'),
        (SELECT id FROM category WHERE name = 'С собой')),
       ((SELECT id FROM meal WHERE name = 'Картошка фри'),
        (SELECT id FROM category WHERE name = 'Фаст фуд')),
       ((SELECT id FROM meal WHERE name = 'Яблочный сок'),
        (SELECT id FROM category WHERE name = 'Напитки')),
       ((SELECT id FROM meal WHERE name = 'Яблочный сок'),
        (SELECT id FROM category WHERE name = 'Холодные напитки')),
       ((SELECT id FROM meal WHERE name = 'Стафф с ветчиной'),
        (SELECT id FROM category WHERE name = 'Пиццы')),
       ((SELECT id FROM meal WHERE name = 'Сосиска в тесте'),
        (SELECT id FROM category WHERE name = 'С собой'));

INSERT discount_card_type (name, discount_amount)
VALUES ('Стандарт', 5),
       ('Серебрянная' , 10),
       ('Золотая', 15);

INSERT discount_card (id, phone, lastname, firstname, midname, email,
                      birth_date, issue_date, discount_card_type_id)

VALUES (123, '+79995554422', 'Шорин', 'Владислав', 'Николаевич',
        'micr@n.ru', '1999-09-09', CURDATE(),
        (SELECT id FROM discount_card_type WHERE name = 'Стандарт')),
       (321, '+78005553535', 'Панин', 'Михаил', 'Сергеевич',
        'miha@sobaka.ru', '1999-03-23', '2007-09-01',
        (SELECT id FROM discount_card_type WHERE name = 'Стандарт')),
       (213, '+79877899878', 'Кожухова', 'Ольга', 'Владимировна',
        'kozh_a@fgh.ru', '2000-01-01', '2018-05-23',
        (SELECT id FROM discount_card_type WHERE name = 'Золотая')),
       (312, '+72223334567', NULL, NULL, 'Михайлович',
        'mihalich@asd.com', NULL, CURDATE(),
        (SELECT id FROM discount_card_type WHERE name = 'Серебрянная')),
       (456, '+71234567890', 'Малютов', 'Никифор', 'Батькович',
        'gde@ya.au', NULL, '2017-07-17',
        (SELECT id FROM discount_card_type WHERE name = 'Серебрянная')),
       (645, '+73243125768', NULL, 'Аркадий', NULL,
        NULL, NULL,'2016-12-12',
        (SELECT id FROM discount_card_type WHERE name = 'Стандарт'));

INSERT discount (start_time, finish_time, amount)
VALUES (CURDATE(), '2019-01-01', 5),
       ('2016-08-02', '2016-08-06', 12),
       ('2018-05-02', '2018-06-02', 7),
       ('2018-12-01', '2018-12-07', 6),
       ('2017-03-19', '2017-03-25', 2);

INSERT pay_method (name)
VALUES ('По карте'),
       ('Наличными');

INSERT `order` (id, price, order_time, pay_method_id, cafe_id,
                discount_id, discount_card_id, is_paid)

VALUES (1, 0, '2018-12-05 18:13:45',
        (SELECT id FROM pay_method WHERE name = 'Наличными'),
        1, NULL, NULL, FALSE),
       (2, 0, '2018-12-05 18:09:45',
        (SELECT id FROM pay_method WHERE name = 'Наличными'),
        1, NULL,
        (SELECT id FROM discount_card WHERE discount_card.phone = '+79995554422'),
        FALSE),
       (3, 0, '2018-09-11 12:10:28',
        (SELECT id FROM pay_method WHERE name = 'По карте'),
        2, NULL, NULL, FALSE),
       (4, 0, '2018-12-10 15:52:11',
        (SELECT id FROM pay_method WHERE name = 'По карте'),
        2, NULL,
        (SELECT id FROM discount_card WHERE discount_card.phone = '+78005553535'),
        FALSE),
       (5, 0, '2018-12-05 17:25:59',
        (SELECT id FROM pay_method WHERE name = 'По карте'),
        1, NULL, NULL, FALSE);

CREATE TRIGGER trigger_update_order_price BEFORE INSERT
ON order_entry FOR EACH ROW
BEGIN
  DECLARE meal_price INT;

  SET meal_price = (SELECT meal.price FROM meal WHERE meal.id = NEW.meal_id LIMIT 1);
  SET NEW.price = meal_price * NEW.amount;

  UPDATE `order`
  SET `order`.price = `order`.price + NEW.price
    WHERE `order`.id = NEW.order_id;
END;

CREATE TRIGGER trigger_apply_discount BEFORE UPDATE
ON `order` FOR EACH ROW
this_trigger:BEGIN
  DECLARE usual_discount INT;
  DECLARE card_discount INT;
  DECLARE order_entries_count INT;

  IF NEW.is_paid = TRUE AND OLD.is_paid = FALSE THEN
    IF NEW.discount_id IS NOT NULL AND NEW.discount_card_id IS NULL THEN
      SET usual_discount = (SELECT discount.amount FROM discount
        WHERE discount.id = NEW.discount_id LIMIT 1);

      SET NEW.price = CEIL(OLD.price * (100 - usual_discount)/100);


    ELSEIF NEW.discount_card_id IS NOT NULL THEN
      SET order_entries_count = (SELECT COUNT(id) FROM order_entry WHERE order_entry.order_id = NEW.id);

      IF order_entries_count <= 5 THEN
        SET card_discount = 5;
      ELSEIF order_entries_count <= 10 AND order_entries_count > 5 THEN
        SET card_discount = 10;
      ELSEIF order_entries_count > 10 THEN
        SET card_discount = 15;
      END IF;

      IF NEW.discount_id IS NULL OR usual_discount < card_discount THEN
        UPDATE `order`
          SET NEW.price = CEIL(OLD.price * (100 - card_discount)/10);
      ELSE
        SET usual_discount = (SELECT discount.amount FROM discount
          WHERE discount.id = NEW.discount_id LIMIT 1);

        UPDATE `order`
          SET NEW.price = CEIL(OLD.price * (100 - usual_discount)/100);
      END IF;
    END IF;
  END IF;
END;

CREATE TRIGGER trigger_update_discount_state_for_order BEFORE INSERT
ON `order` FOR EACH ROW
BEGIN
  SET NEW.discount_id = (SELECT id FROM discount
    WHERE discount.finish_time >= CURDATE()
          AND discount.start_time <= CURDATE() LIMIT 1);
END;

insert into order_entry (price, amount, meal_id, order_id)
values (0, 2, (SELECT id FROM meal WHERE name = 'Салат цезарь'), 1),
       (0, 5, (SELECT id FROM meal WHERE name = 'Картошка фри'), 1),
       (0, 2, (SELECT id FROM meal WHERE name = 'Яблочный сок'), 1),

       (0, 1, (SELECT id FROM meal WHERE name = 'Стафф с ветчиной'), 2),
       (0, 1, (SELECT id FROM meal WHERE name = 'Шаурма со свининой'), 2),
       (0, 1, (SELECT id FROM meal WHERE name = 'Сливочная маргарита'), 2),
       (0, 2, (SELECT id FROM meal WHERE name = 'Латте с ванилью'), 2),

       (0, 1, (SELECT id FROM meal WHERE name = 'Сосиска в тесте'), 3),

       (0, 20, (SELECT id FROM meal WHERE name = 'Шаурма со свининой'), 4),
       (0, 1, (SELECT id FROM meal WHERE name = 'Яблочный сок'), 4),

       (0, 1, (SELECT id FROM meal WHERE name = 'Сливочная маргарита'), 5),
       (0, 2, (SELECT id FROM meal WHERE name = 'Латте с ванилью'), 5);
