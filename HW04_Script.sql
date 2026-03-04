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








