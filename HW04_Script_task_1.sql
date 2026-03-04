-- Создаем БД для музыкального сервиса

-- 1. Создаем таблицу Жанры

CREATE TABLE  IF NOT EXISTS Genres (
	genre_id SERIAL PRIMARY KEY,
	title VARCHAR(50) UNIQUE NOT NULL
);

-- 2. Создаем таблицу Исполнители

CREATE TABLE IF NOT EXISTS Performers (
	performer_id SERIAL PRIMARY KEY,
	name VARCHAR(128) NOT NULL
);

-- 3. Создаем таблицу Альбомы

CREATE TABLE IF NOT EXISTS Albums (
	album_id SERIAL PRIMARY KEY,
	title_album VARCHAR(255) NOT NULL,
	year_of_release INTEGER CHECK (year_of_release >= 1900)
);

-- 4. Создаем таблицу Треки

CREATE TABLE IF NOT EXISTS Tracks (
	track_id SERIAL PRIMARY KEY,
	track_title VARCHAR(255) NOT NULL,
	lasting INTEGER CHECK (lasting > 0),
	album_id INTEGER REFERENCES Albums(album_id) ON DELETE CASCADE NOT NULL
);

-- 5. Создаем таблицу Сборники

CREATE TABLE IF NOT EXISTS Collections (
	collection_id SERIAL PRIMARY KEY,
	title_collection VARCHAR(255) NOT NULL,
	year_of_release INTEGER CHECK (year_of_release >= 1900)
);

-- 6.1 Создаем промежуточную таблицу для связи Исполнители-Жанры

CREATE TABLE IF NOT EXISTS Performer_Genre (
	performer_genre SERIAL PRIMARY KEY,
	performer_id INTEGER REFERENCES Performers(performer_id) ON DELETE CASCADE,
	genre_id INTEGER REFERENCES Genres(genre_id) ON DELETE CASCADE
);

-- 6.2 Создаем промежуточную таблицу для связи Альбомы-Исполнители

CREATE TABLE IF NOT EXISTS Album_Performer (
	album_performer_id SERIAL PRIMARY KEY,
	album_id INTEGER REFERENCES Albums(album_id) ON DELETE CASCADE,
	performer_id INTEGER REFERENCES Performers(performer_id) ON DELETE CASCADE
);

-- 6.3 Создаем промежуточную таблицу для связи Треки-Сборники

CREATE TABLE IF NOT EXISTS Track_Collection (
	track_collection_id SERIAL PRIMARY KEY,
	track_id INTEGER REFERENCES Tracks(track_id) ON DELETE CASCADE,
	collection_id INTEGER REFERENCES Collections(collection_id) ON DELETE CASCADE
);

-- 7.1 Заполняем таблицу Исполнители (не менее 4)
INSERT INTO Performers (name) VALUES 
    ('Muse'),
    ('Daft Punk'),
    ('Земфира'),
    ('Linkin Park'),
    ('Ленинград');

-- 7.2 Заполняем таблицу Жанры (не менее 3)
INSERT INTO Genres (title) VALUES 
    ('Рок'),
    ('Поп'),
    ('Электроника'),
    ('Хип-хоп');

-- 7.3 Заполняем таблицу Альбомы (не менее 3)
INSERT INTO Albums (title_album, year_of_release) VALUES 
    ('Black Holes and Revelations', 2006),
    ('Random Access Memories', 2013),
    ('Zemfira', 1999),
    ('Meteora', 2003);

-- 7.4 Заполняем таблицу Треки (не менее 6, добавляем треки с "мой" и "my" для Задания 2)
INSERT INTO Tracks (track_title, lasting, album_id) VALUES 
    ('Starlight', 236, 1),          
    ('Supermassive Black Hole', 212, 1), 
    ('Get Lucky', 248, 2),           
    ('Instant Crush', 337, 2),       
    ('Почему', 223, 3),              
    ('Ромашки', 186, 3),             
    ('Numb', 185, 4),                
    ('In the End', 216, 4),
    ('My Generation', 195, 1),        -- трек с "my"
    ('Мой друг', 210, 3),             -- трек с "мой"
    ('Мой рок-н-ролл', 240, 3),       -- трек с "мой"
    ('My Immortal', 260, 4);          -- трек с "my"

-- 7.5 Заполняем таблицу Сборники (не менее 4)
INSERT INTO Collections (title_collection, year_of_release) VALUES 
    ('Лучшие рок-хиты 2000-х', 2010),
    ('Танцевальная вечеринка', 2015),
    ('Легенды русского рока', 2018),
    ('Электронная коллекция', 2020),
    ('Рок-баллады', 2012);    
    
-- 8.1 Заполненяем связи Исполнители-Жанры
INSERT INTO Performer_Genre (performer_id, genre_id) VALUES 
    (1, 1), -- Muse - Рок
    (2, 3), -- Daft Punk - Электроника
    (2, 1), -- Daft Punk также можно отнести к року
    (3, 1), -- Земфира - Рок
    (3, 2), -- Земфира также Поп
    (4, 1), -- Linkin Park - Рок
    (4, 4), -- Linkin Park также Хип-хоп
    (5, 1), -- Ленинград - Рок
    (5, 2); -- Ленинград также Поп    
    
-- 8.2 Заполняем связи Альбомы-Исполнители
INSERT INTO Album_Performer (album_id, performer_id) VALUES 
    (1, 1), -- Black Holes and Revelations - Muse
    (2, 2), -- Random Access Memories - Daft Punk
    (3, 3), -- Zemfira - Земфира
    (4, 4), -- Meteora - Linkin Park
    (3, 5); -- В альбоме Земфиры есть песня, где участвует Ленинград

-- 8.3 Заполняем связи Треки-Сборники
INSERT INTO Track_Collection (track_id, collection_id) VALUES    
    (1, 1), (2, 1), (7, 1), (9, 1), (12, 1),  -- Сборник "Лучшие рок-хиты 2000-х" (1)
    (3, 2), (4, 2), -- Сборник "Танцевальная вечеринка" (2)       
    (5, 3), (6, 3), (10, 3), (11, 3), -- Сборник "Легенды русского рока" (3)
    (3, 4), (4, 4), -- Сборник "Электронная коллекция" (4)      
    (1, 5), (7, 5), (5, 5), (9, 5), (12, 5); -- Сборник "Рок-баллады" (5)   
    
    


