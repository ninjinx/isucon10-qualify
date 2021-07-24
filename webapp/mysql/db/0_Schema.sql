DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(4096) NOT NULL,
  `thumbnail` varchar(128) NOT NULL,
  `address` varchar(128) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `rent` int(11) NOT NULL,
  `door_height` int(11) NOT NULL,
  `door_width` int(11) NOT NULL,
  `features` varchar(64) NOT NULL,
  `popularity` int(11) NOT NULL,
  `search_popularity` int(11) GENERATED ALWAYS AS (concat(-(`popularity`))) STORED NOT NULL,
  `locate` geometry GENERATED ALWAYS AS (
    st_geometryfromtext(concat('POINT(', `latitude`, ' ', `longitude`, ')'))
  ) STORED,
  `search_condition_id` int(11) GENERATED ALWAYS AS (concat(
    (CASE WHEN door_width >= 150 THEN 3 WHEN door_width >= 110 THEN 2 WHEN door_width >= 80 THEN 1 ELSE 0 END),
    (CASE WHEN door_height >= 150 THEN 3 WHEN door_height >= 110 THEN 2 WHEN door_height >= 80 THEN 1 ELSE 0 END),
    (CASE WHEN rent >= 150000 THEN 3 WHEN rent >= 100000 THEN 2 WHEN rent >= 50000 THEN 1 ELSE 0 END)
    )) STORED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nazotte_filter` (`latitude`, `longitude`),
  KEY `door_size` (`door_width`, `door_height`),
  KEY `search_condition` (`search_condition_id`),
  KEY `popularity_sort` (`search_popularity`, `id`),
  KEY `low_price_sort` (`rent`, `id`)
);

CREATE TABLE isuumo.chair (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  description VARCHAR(4096) NOT NULL,
  thumbnail VARCHAR(128) NOT NULL,
  price INTEGER NOT NULL,
  height INTEGER NOT NULL,
  width INTEGER NOT NULL,
  depth INTEGER NOT NULL,
  color VARCHAR(64) NOT NULL,
  features VARCHAR(64) NOT NULL,
  kind VARCHAR(64) NOT NULL,
  popularity INTEGER NOT NULL,
  stock INTEGER NOT NULL,
  `search_popularity` int(11) GENERATED ALWAYS AS (concat(-(`popularity`))) STORED NOT NULL,
  KEY `popularity_sort` (`search_popularity`, `id`),
  KEY `price_sort` (`price`, `id`),
  KEY `stock` (`stock`)
);
