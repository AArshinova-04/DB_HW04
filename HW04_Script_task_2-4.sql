-- Задание 2
-- 2.1. Название и продолжительность самого длительного трека
SELECT track_title, lasting 
FROM Tracks 
ORDER BY lasting DESC 
LIMIT 1;

-- 2.2. Название треков, продолжительность которых не менее 3,5 минут (210 секунд)
SELECT track_title, lasting 
FROM Tracks 
WHERE lasting >= 210  -- 3.5 минут = 210 секунд
ORDER BY lasting;

-- 2.3. Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT title_collection, year_of_release 
FROM Collections 
WHERE year_of_release BETWEEN 2018 AND 2020
ORDER BY year_of_release;

-- 2.4. Исполнители, чьё имя состоит из одного слова
SELECT name 
FROM Performers 
WHERE name NOT LIKE '% %'  -- не содержит пробелов
  AND name NOT LIKE '%-%'  -- не содержит дефисов (исключаем составные имена)
ORDER BY name;

-- 2.5. Название треков, которые содержат слово «мой» или «my»
SELECT track_title 
FROM Tracks 
WHERE LOWER(track_title) LIKE '% мой %' -- слово "мой" в середине
   OR LOWER(track_title) LIKE 'мой %' -- слово "мой" в начале
   OR LOWER(track_title) LIKE '% мой' -- слово "мой" в конце
   OR LOWER(track_title) = 'мой' -- слово "мой" целиком
   OR LOWER(track_title) LIKE '%мой%' -- "мой" как часть слова
   OR LOWER(track_title) LIKE '% my %' -- слово "my" в середине
   OR LOWER(track_title) LIKE 'my %' -- слово "my" в начале
   OR LOWER(track_title) LIKE '% my' -- слово "my" в конце
   OR LOWER(track_title) = 'my'; -- слово "my" целиком
   OR LOWER(track_title) LIKE '%my%' -- "my" как часть слова

   track_title 
   
   
-- Задание 3
-- 3.1. Количество исполнителей в каждом жанре
SELECT 
    g.title AS жанр,
    COUNT(pg.performer_id) AS количество_исполнителей
FROM Genres g
LEFT JOIN Performer_Genre pg ON g.genre_id = pg.genre_id
GROUP BY g.title
ORDER BY количество_исполнителей DESC;

-- 3.2. Количество треков, вошедших в альбомы 2019–2020 годов
-- Добавим недостающие данные для запроса (альбомы 2019-2020 годов):

-- Добавляем альбомы 2019-2020 годов, чтобы 2-й запрос не был пустым
INSERT INTO Albums (title_album, year_of_release) VALUES 
    ('Simulation Theory', 2019), -- альбом Muse
    ('Medicine at Midnight', 2020); -- альбом Foo Fighters (новый исполнитель)

-- Добавляем нового исполнителя для нового альбома
INSERT INTO Performers (name) VALUES 
    ('Foo Fighters');

-- Добавляем треки в новые альбомы
INSERT INTO Tracks (track_title, lasting, album_id) VALUES 
    ('Pressure', 196, 5), -- альбом 5 (Simulation Theory)
    ('The Dark Side', 227, 5), -- альбом 5 (Simulation Theory)
    ('Making a Fire', 255, 6), -- альбом 6 (Medicine at Midnight)
    ('Waiting on a War', 286, 6); -- альбом 6 (Medicine at Midnight)

-- Связываем новые альбомы с исполнителями
INSERT INTO Album_Performer (album_id, performer_id) VALUES 
    (5, 1), -- Simulation Theory - Muse
    (6, 6); -- Medicine at Midnight - Foo Fighters (performer_id = 6)

-- Добавляем треки в сборники
INSERT INTO Track_Collection (track_id, collection_id) VALUES 
    (13, 1), (14, 1), (13, 4), (14, 4), (15, 2), (16, 2), (15, 4), (16, 4);


-- Количество треков, вошедших в альбомы 2019–2020 годов
SELECT 
    COUNT(t.track_id) AS количество_треков
FROM Tracks t
JOIN Albums a ON t.album_id = a.album_id
WHERE a.year_of_release BETWEEN 2019 AND 2020;

-- 3.3. Средняя продолжительность треков по каждому альбому
SELECT 
    a.title_album AS альбом,
    ROUND(AVG(t.lasting), 2) AS средняя_продолжительность_секунд,
    CONCAT(
        FLOOR(AVG(t.lasting) / 60), ' мин ',
        FLOOR(AVG(t.lasting) - FLOOR(AVG(t.lasting) / 60) * 60), ' сек'
    ) AS средняя_продолжительность
FROM Albums a
JOIN Tracks t ON a.album_id = t.album_id
GROUP BY a.title_album, a.album_id
ORDER BY AVG(t.lasting) DESC;

-- 3.4. Все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT 
    p.name AS исполнитель
FROM Performers p
WHERE p.performer_id NOT IN (
    SELECT DISTINCT ap.performer_id
    FROM Album_Performer ap
    JOIN Albums a ON ap.album_id = a.album_id
    WHERE a.year_of_release = 2020
)
ORDER BY p.name;

-- 3.5. Названия сборников, в которых присутствует конкретный исполнитель
-- Выберем исполнителя "Muse" (performer_id = 1)
SELECT DISTINCT
    c.title_collection AS сборник,
    c.year_of_release AS год_выпуска
FROM Collections c
JOIN Track_Collection tc ON c.collection_id = tc.collection_id
JOIN Tracks t ON tc.track_id = t.track_id
JOIN Albums a ON t.album_id = a.album_id
JOIN Album_Performer ap ON a.album_id = ap.album_id
JOIN Performers p ON ap.performer_id = p.performer_id
WHERE p.name = 'Muse'
ORDER BY c.year_of_release;   

-- Задание 4(необязательное)
-- 4.1. Названия альбомов, в которых присутствуют исполнители более чем одного жанра
-- Добавляем нового исполнителя с несколькими жанрами для разнообразия
INSERT INTO Performers (name) VALUES ('Gorillaz');
INSERT INTO Performer_Genre (performer_id, genre_id) VALUES 
    (7, 1), (7, 3), (7, 4); -- Gorillaz: Рок, Электроника, Хип-хоп

-- Добавляем альбом для Gorillaz
INSERT INTO Albums (title_album, year_of_release) VALUES ('Demon Days', 2005);
INSERT INTO Album_Performer (album_id, performer_id) VALUES (7, 7);
INSERT INTO Tracks (track_title, lasting, album_id) VALUES 
    ('Feel Good Inc.', 222, 7),
    ('Dare', 244, 7);

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT DISTINCT
    a.title_album AS альбом,
    p.name AS исполнитель
FROM Albums a
JOIN Album_Performer ap ON a.album_id = ap.album_id
JOIN Performers p ON ap.performer_id = p.performer_id
WHERE p.performer_id IN (
    SELECT performer_id
    FROM Performer_Genre
    GROUP BY performer_id
    HAVING COUNT(genre_id) > 1
)
ORDER BY a.title_album;

-- 4.2. Наименования треков, которые не входят в сборники
-- Добавляем несколько треков без связей
INSERT INTO Tracks (track_title, lasting, album_id) VALUES 
    ('One More Time', 320, 2),      -- Daft Punk трек не в сборниках
    ('Hysteria', 227, 1),           -- Muse трек не в сборниках
    ('Без вариантов', 198, 3);      -- Земфира трек не в сборниках

-- Наименования треков, которые не входят в сборники
SELECT 
    t.track_title AS трек,
    t.lasting AS продолжительность,
    a.title_album AS альбом
FROM Tracks t
LEFT JOIN Track_Collection tc ON t.track_id = tc.track_id
JOIN Albums a ON t.album_id = a.album_id
WHERE tc.track_id IS NULL
ORDER BY t.track_title;

-- 4.3. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
-- Добавим очень короткий трек
INSERT INTO Tracks (track_title, lasting, album_id) VALUES 
    ('Интро', 30, 3), -- очень короткий трек Земфиры
    ('We Will Rock You', 122, 1); -- короткий трек Muse
    
-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
WITH min_duration AS (
    SELECT MIN(lasting) as min_lasting
    FROM Tracks
)
SELECT 
    p.name AS исполнитель,
    t.track_title AS трек,
    t.lasting AS продолжительность_секунд,
    CONCAT(FLOOR(t.lasting / 60), ' мин ', t.lasting % 60, ' сек') AS продолжительность
FROM Tracks t
JOIN Albums a ON t.album_id = a.album_id
JOIN Album_Performer ap ON a.album_id = ap.album_id
JOIN Performers p ON ap.performer_id = p.performer_id
CROSS JOIN min_duration md
WHERE t.lasting = md.min_lasting
ORDER BY p.name;

-- 4.4. Названия альбомов, содержащих наименьшее количество треков
-- Добавим альбом с одним треком
INSERT INTO Albums (title_album, year_of_release) VALUES ('Single Album', 2023);
INSERT INTO Album_Performer (album_id, performer_id) VALUES (8, 1); -- Muse
INSERT INTO Tracks (track_title, lasting, album_id) VALUES 
    ('One and Only', 180, 8);

-- Названия альбомов, содержащих наименьшее количество треков
WITH track_counts AS (
    SELECT 
        a.album_id,
        a.title_album,
        COUNT(t.track_id) AS track_count
    FROM Albums a
    LEFT JOIN Tracks t ON a.album_id = t.album_id
    GROUP BY a.album_id, a.title_album
),
min_track_count AS (
    SELECT MIN(track_count) as min_count
    FROM track_counts
)
SELECT 
    tc.title_album AS альбом,
    tc.track_count AS количество_треков,
    STRING_AGG(t.track_title, ', ') AS список_треков
FROM track_counts tc
CROSS JOIN min_track_count mtc
LEFT JOIN Tracks t ON tc.album_id = t.album_id
WHERE tc.track_count = mtc.min_count
GROUP BY tc.title_album, tc.track_count
ORDER BY tc.title_album;






























   