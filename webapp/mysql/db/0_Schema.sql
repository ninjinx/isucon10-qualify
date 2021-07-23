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
  PRIMARY KEY (`id`),
  KEY `nazotte_filter` (`latitude`, `longitude`),
  KEY `nazotte_sort` (`search_popularity`, `id`),
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
  stock INTEGER NOT NULL
);
