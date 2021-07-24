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
  `search_condition_id` int(11) GENERATED ALWAYS AS (concat(
    (CASE WHEN height >= 150 THEN 3 WHEN height >= 110 THEN 2 WHEN height >= 80 THEN 1 ELSE 0 END),
    (CASE WHEN width >= 150 THEN 3 WHEN width >= 110 THEN 2 WHEN width >= 80 THEN 1 ELSE 0 END),
    (CASE WHEN depth >= 150 THEN 3 WHEN depth >= 110 THEN 2 WHEN depth >= 80 THEN 1 ELSE 0 END),
    (CASE WHEN price >= 15000 THEN 5 WHEN price >= 12000 THEN 4 WHEN price >= 9000 THEN 3 WHEN price >= 6000 THEN 2 WHEN price >= 3000 THEN 1 ELSE 0 END)
    )) STORED NOT NULL,
  `kind_id` int(11) GENERATED ALWAYS AS (concat(
    (CASE WHEN kind = "ゲーミングチェア" THEN 1 WHEN kind = "座椅子" THEN 2 WHEN kind = "エルゴノミクス" THEN 3 WHEN kind = "ハンモック" THEN 4 ELSE 0 END)
    )) STORED NOT NULL,
  `color_id` int(11) GENERATED ALWAYS AS (concat(
    (CASE WHEN color = "黒" THEN "01" WHEN color = "白" THEN "02" WHEN color = "赤" THEN "03" WHEN color = "青" THEN "04" WHEN color = "緑" THEN "05" WHEN color = "黄" THEN "06" WHEN color = "紫" THEN "07" WHEN color = "ピンク" THEN "08" WHEN color = "オレンジ" THEN "09" WHEN color = "水色" THEN "10" WHEN color = "ネイビー" THEN "11" WHEN color = "ベージュ" THEN "12" ELSE "00" END)
    )) STORED NOT NULL,
  KEY `popularity_sort` (`search_popularity`, `id`),
  KEY `price_sort` (`price`, `id`),
  KEY `stock` (`stock`),
  KEY `kind` (`kind_id`, `stock`),
  KEY `color` (`color_id`, `stock`),
  KEY `search_condition` (`search_condition_id`, `stock`)
);
