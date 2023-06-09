/**
Напишите запрос, возвращающий имя и число указанных телефонных номеров девушек в возрасте от 18 до 22 лет.
Оптимизируйте таблицы и запрос при необходимости.
 */


CREATE TABLE `users`
(
    `id`         INT(11) NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(255) DEFAULT NULL,
    `gender`     INT(11) NOT NULL COMMENT '0 - не указан, 1 - мужчина, 2 - женщина.',
    `birth_date` INT(11) NOT NULL COMMENT 'Дата в unixtime.',
    PRIMARY KEY (`id`)
);
CREATE TABLE `phone_numbers`
(
    `id`      INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` INT(11) NOT NULL,
    `phone`   VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
);

alter table users modify gender TINYINT(1) NOT NULL COMMENT '0 - не указан, 1 - мужчина, 2 - женщина.';

INSERT INTO users (name, gender, birth_date)
VALUES ('a', 1, UNIX_TIMESTAMP(STR_TO_DATE('Apr 15 2002 12:00AM', '%M %d %Y %h:%i%p'))),
       ('a', 2, UNIX_TIMESTAMP(STR_TO_DATE('Apr 15 1999 12:00AM', '%M %d %Y %h:%i%p'))),
       ('b', 2, UNIX_TIMESTAMP(STR_TO_DATE('Apr 15 2006 12:00AM', '%M %d %Y %h:%i%p'))),
       ('b', 2, UNIX_TIMESTAMP(STR_TO_DATE('Apr 15 2002 12:00AM', '%M %d %Y %h:%i%p'))),
       ('c', 2, UNIX_TIMESTAMP(STR_TO_DATE('Apr 15 2003 12:00AM', '%M %d %Y %h:%i%p'))),
       ('c', 2, UNIX_TIMESTAMP(STR_TO_DATE('Apr 15 2004 12:00AM', '%M %d %Y %h:%i%p')));

INSERT INTO phone_numbers (user_id, phone)
VALUES (1, '12345'),
       (2, '23456'),
       (3, '34567'),
       (4, '45678'),
       (5, '56789'),
       (6, '67891');

ALTER TABLE users
    ADD INDEX idx_gender (gender),
    ADD INDEX idx_birth_date (birth_date);

ALTER TABLE phone_numbers
    ADD INDEX idx_user_id (user_id);

SELECT
    u.name,
    COUNT(p.phone) AS phone_count
FROM users u
         JOIN phone_numbers p ON u.id = p.user_id
WHERE u.gender = 2
  AND u.birth_date >= UNIX_TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 22 YEAR))
  AND u.birth_date <= UNIX_TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 18 YEAR))
GROUP BY u.name;

