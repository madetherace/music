USE master;
DROP DATABASE IF EXISTS Music;
CREATE DATABASE Music;
GO
USE Music;
GO--1. �������� �� ����� ��� ������ �����.-- �������� ������� ����� ��� ������������
CREATE TABLE Artist (
    ID INT PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Genre NVARCHAR(100)
) AS NODE;

-- �������� ������� ����� ��� ��������
CREATE TABLE Album (
    ID INT PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    ReleaseYear INT
) AS NODE;

-- �������� ������� ����� ��� �����
CREATE TABLE Song (
    ID INT PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    DurationMinutes DECIMAL(4,2)
) AS NODE;
--2. �������� �� ����� ��� ������ ����
-- �����: ����������� �������� ������
CREATE TABLE ReleasedAlbum (
    ReleaseDate DATE
) AS EDGE;

-- �����: ����� ����������� �������
CREATE TABLE BelongsToAlbum (
    TrackNumber INT
) AS EDGE;

-- �����: ����������� �������� ����� (�������� �����������)
CREATE TABLE PerformedSong (
    Role NVARCHAR(50) DEFAULT 'Main Artist' -- ��������, 'Main Artist', 'Featured Artist'
) AS EDGE;

-- �������������� �����: ����������� ���������� � ������ ����� (��� �����)
-- ��� ����� ����������� ����� PerformedSong � ������ �����, ���� ��������� ������:
CREATE TABLE FeaturedOnSong (
    Notes NVARCHAR(255) -- �������������� ������� � ��������������
) AS EDGE;

-- �������������� �����: �������������� ����� ��������� (��������, �� ����� ��� � �����)
CREATE TABLE CollaboratedWith (
    CollaborationType NVARCHAR(100) -- 'Song', 'Album', 'Band'
) AS EDGE;

-- ������� ��� �������� ����� ��� ������:
-- 1. ReleasedAlbum (Artist -> Album)
-- 2. BelongsToAlbum (Song -> Album)
-- 3. PerformedSong (Artist -> Song)
-- ���� ����� ����� �������� � �������� ������������, ����� �������� FeaturedOnSong ��� ������������ PerformedSong � ������� ������.

--3. ��������� ��� ������ ������ ����� �� ����� 10 �����.
INSERT INTO Artist (ID, Name, Genre) VALUES
(1, 'Young Thug', 'Hip Hop/Trap'),
(2, 'Ken Carson', 'Hip Hop/Rage'),
(3, 'Future', 'Hip Hop/Trap'),
(4, 'Travis Scott', 'Hip Hop/Trap'),
(5, 'Playboi Carti', 'Hip Hop/Rage'),
(6, 'Lil Uzi Vert', 'Hip Hop/Trap'),
(7, 'Drake', 'Hip Hop/R&B'),
(8, 'Kanye West', 'Hip Hop/Experimental'),
(9, 'Kendrick Lamar', 'Hip Hop'),
(10, 'J. Cole', 'Hip Hop'),
(11, 'Gunna', 'Hip Hop/Trap');

INSERT INTO Album (ID, Title, ReleaseYear) VALUES
(101, 'So Much Fun', 2019),        -- Young Thug
(102, 'PUNK', 2021),               -- Young Thug
(103, 'Project X', 2021),          -- Ken Carson
(104, 'X', 2022),                  -- Ken Carson
(105, 'DS2', 2015),                -- Future
(106, 'HNDRXX', 2017),             -- Future
(107, 'ASTROWORLD', 2018),         -- Travis Scott
(108, 'UTOPIA', 2023),             -- Travis Scott
(109, 'Whole Lotta Red', 2020),    -- Playboi Carti
(110, 'Eternal Atake', 2020),      -- Lil Uzi Vert
(111, 'Certified Lover Boy', 2021); -- Drake

INSERT INTO Song (ID, Title, DurationMinutes) VALUES
-- Young Thug - So Much Fun
(201, 'Hot', 3.13),
(202, 'The London', 3.20),
-- Ken Carson - X
(203, 'Go', 2.00),
(204, 'MDMA', 2.30), -- feat. Destroy Lonely 
-- Future - DS2
(205, 'Thought It Was a Drought', 4.25),
(206, 'Stick Talk', 2.50),
-- Travis Scott - ASTROWORLD
(207, 'SICKO MODE', 5.12),
(208, 'STARGAZING', 4.31),
-- Playboi Carti - Whole Lotta Red
(209, 'Sky', 3.10),
-- Lil Uzi Vert - Eternal Atake
(210, 'Baby Pluto', 3.30),
-- Drake - Certified Lover Boy
(211, 'Way 2 Sexy', 4.17),
-- Young Thug - PUNK
(212, 'Livin It Up', 3.30),
-- Future - HNDRXX
(213, 'Mask Off', 3.24),
-- Travis Scott - UTOPIA
(214, 'FE!N', 3.12);

--4. ������� ������ � ������� ���� ��� ������������ ������ ����� ����� ������.
-- ����� ����������� -> ������ (ReleasedAlbum)
-- ��� ����� ��� ����� $node_id ������������ � ��������
INSERT INTO ReleasedAlbum ($from_id, $to_id, ReleaseDate) VALUES
((SELECT $node_id FROM Artist WHERE ID = 1), (SELECT $node_id FROM Album WHERE ID = 101), '2019-08-16'), -- Young Thug -> So Much Fun
((SELECT $node_id FROM Artist WHERE ID = 1), (SELECT $node_id FROM Album WHERE ID = 102), '2021-10-15'), -- Young Thug -> PUNK
((SELECT $node_id FROM Artist WHERE ID = 2), (SELECT $node_id FROM Album WHERE ID = 103), '2021-07-23'), -- Ken Carson -> Project X
((SELECT $node_id FROM Artist WHERE ID = 2), (SELECT $node_id FROM Album WHERE ID = 104), '2022-07-08'), -- Ken Carson -> X
((SELECT $node_id FROM Artist WHERE ID = 3), (SELECT $node_id FROM Album WHERE ID = 105), '2015-07-17'), -- Future -> DS2
((SELECT $node_id FROM Artist WHERE ID = 3), (SELECT $node_id FROM Album WHERE ID = 106), '2017-02-24'), -- Future -> HNDRXX
((SELECT $node_id FROM Artist WHERE ID = 4), (SELECT $node_id FROM Album WHERE ID = 107), '2018-08-03'), -- Travis Scott -> ASTROWORLD
((SELECT $node_id FROM Artist WHERE ID = 4), (SELECT $node_id FROM Album WHERE ID = 108), '2023-07-28'), -- Travis Scott -> UTOPIA
((SELECT $node_id FROM Artist WHERE ID = 5), (SELECT $node_id FROM Album WHERE ID = 109), '2020-12-25'), -- Playboi Carti -> Whole Lotta Red
((SELECT $node_id FROM Artist WHERE ID = 6), (SELECT $node_id FROM Album WHERE ID = 110), '2020-03-06'), -- Lil Uzi Vert -> Eternal Atake
((SELECT $node_id FROM Artist WHERE ID = 7), (SELECT $node_id FROM Album WHERE ID = 111), '2021-09-03'); -- Drake -> Certified Lover Boy

-- ����� ����� -> ������ (BelongsToAlbum)
INSERT INTO BelongsToAlbum ($from_id, $to_id, TrackNumber) VALUES
((SELECT $node_id FROM Song WHERE ID = 201), (SELECT $node_id FROM Album WHERE ID = 101), 1), -- Hot -> So Much Fun
((SELECT $node_id FROM Song WHERE ID = 202), (SELECT $node_id FROM Album WHERE ID = 101), 2), -- The London -> So Much Fun
((SELECT $node_id FROM Song WHERE ID = 203), (SELECT $node_id FROM Album WHERE ID = 104), 1), -- Go -> X
((SELECT $node_id FROM Song WHERE ID = 204), (SELECT $node_id FROM Album WHERE ID = 104), 2), -- MDMA -> X
((SELECT $node_id FROM Song WHERE ID = 205), (SELECT $node_id FROM Album WHERE ID = 105), 1), -- Thought It Was a Drought -> DS2
((SELECT $node_id FROM Song WHERE ID = 206), (SELECT $node_id FROM Album WHERE ID = 105), 2), -- Stick Talk -> DS2
((SELECT $node_id FROM Song WHERE ID = 207), (SELECT $node_id FROM Album WHERE ID = 107), 1), -- SICKO MODE -> ASTROWORLD
((SELECT $node_id FROM Song WHERE ID = 208), (SELECT $node_id FROM Album WHERE ID = 107), 2), -- STARGAZING -> ASTROWORLD
((SELECT $node_id FROM Song WHERE ID = 209), (SELECT $node_id FROM Album WHERE ID = 109), 1), -- Sky -> Whole Lotta Red
((SELECT $node_id FROM Song WHERE ID = 210), (SELECT $node_id FROM Album WHERE ID = 110), 1), -- Baby Pluto -> Eternal Atake
((SELECT $node_id FROM Song WHERE ID = 211), (SELECT $node_id FROM Album WHERE ID = 111), 1), -- Way 2 Sexy -> Certified Lover Boy
((SELECT $node_id FROM Song WHERE ID = 212), (SELECT $node_id FROM Album WHERE ID = 102), 1), -- Livin It Up -> PUNK
((SELECT $node_id FROM Song WHERE ID = 213), (SELECT $node_id FROM Album WHERE ID = 106), 1), -- Mask Off -> HNDRXX
((SELECT $node_id FROM Song WHERE ID = 214), (SELECT $node_id FROM Album WHERE ID = 108), 1); -- FE!N -> UTOPIA


-- ����� ����������� -> ����� (PerformedSong)
INSERT INTO PerformedSong ($from_id, $to_id, Role) VALUES
((SELECT $node_id FROM Artist WHERE ID = 1), (SELECT $node_id FROM Song WHERE ID = 201), 'Main Artist'), -- Young Thug -> Hot
((SELECT $node_id FROM Artist WHERE ID = 1), (SELECT $node_id FROM Song WHERE ID = 202), 'Main Artist'), -- Young Thug -> The London
((SELECT $node_id FROM Artist WHERE ID = 2), (SELECT $node_id FROM Song WHERE ID = 203), 'Main Artist'), -- Ken Carson -> Go
((SELECT $node_id FROM Artist WHERE ID = 2), (SELECT $node_id FROM Song WHERE ID = 204), 'Main Artist'), -- Ken Carson -> MDMA
((SELECT $node_id FROM Artist WHERE ID = 3), (SELECT $node_id FROM Song WHERE ID = 205), 'Main Artist'), -- Future -> Thought It Was a Drought
((SELECT $node_id FROM Artist WHERE ID = 3), (SELECT $node_id FROM Song WHERE ID = 206), 'Main Artist'), -- Future -> Stick Talk
((SELECT $node_id FROM Artist WHERE ID = 4), (SELECT $node_id FROM Song WHERE ID = 207), 'Main Artist'), -- Travis Scott -> SICKO MODE
((SELECT $node_id FROM Artist WHERE ID = 4), (SELECT $node_id FROM Song WHERE ID = 208), 'Main Artist'), -- Travis Scott -> STARGAZING
((SELECT $node_id FROM Artist WHERE ID = 5), (SELECT $node_id FROM Song WHERE ID = 209), 'Main Artist'), -- Playboi Carti -> Sky
((SELECT $node_id FROM Artist WHERE ID = 6), (SELECT $node_id FROM Song WHERE ID = 210), 'Main Artist'), -- Lil Uzi Vert -> Baby Pluto
((SELECT $node_id FROM Artist WHERE ID = 7), (SELECT $node_id FROM Song WHERE ID = 211), 'Main Artist'), -- Drake -> Way 2 Sexy
((SELECT $node_id FROM Artist WHERE ID = 1), (SELECT $node_id FROM Song WHERE ID = 212), 'Main Artist'), -- Young Thug -> Livin It Up
((SELECT $node_id FROM Artist WHERE ID = 3), (SELECT $node_id FROM Song WHERE ID = 213), 'Main Artist'), -- Future -> Mask Off
((SELECT $node_id FROM Artist WHERE ID = 4), (SELECT $node_id FROM Song WHERE ID = 214), 'Main Artist'); -- Travis Scott -> FE!N

-- ������� ��������� "�����" ��� ������������ ����� ������� ������, ���� ���������� FeaturedOnSong ��� PerformedSong � ������� ������.
-- ������ � PerformedSong � ����� 'Featured Artist':
-- �����������, �� ����� "The London" (ID 202) ���� J. Cole (ID 10) � Travis Scott (ID 4) ��� �����
INSERT INTO PerformedSong ($from_id, $to_id, Role) VALUES
((SELECT $node_id FROM Artist WHERE ID = 10), (SELECT $node_id FROM Song WHERE ID = 202), 'Featured Artist'), -- J. Cole on The London
((SELECT $node_id FROM Artist WHERE ID = 4), (SELECT $node_id FROM Song WHERE ID = 202), 'Featured Artist'); -- Travis Scott on The London

-- �����������, �� ����� "SICKO MODE" (ID 207) ���� Drake (ID 7) ��� �����
INSERT INTO PerformedSong ($from_id, $to_id, Role) VALUES
((SELECT $node_id FROM Artist WHERE ID = 7), (SELECT $node_id FROM Song WHERE ID = 207), 'Featured Artist'); -- Drake on SICKO MODE

-- �����������, �� ����� "FE!N" (ID 214) ���� Playboi Carti (ID 5) ��� �����
INSERT INTO PerformedSong ($from_id, $to_id, Role) VALUES
((SELECT $node_id FROM Artist WHERE ID = 5), (SELECT $node_id FROM Song WHERE ID = 214), 'Featured Artist'); -- Playboi Carti on FE!N

-- ����� ��� CollaboratedWith (����������� -> �����������)
-- ��� ����� ���� �������� �� ���������� ������ ��� ������ �������������.
-- Young Thug � Travis Scott �� "The London"
INSERT INTO CollaboratedWith ($from_id, $to_id, CollaborationType) VALUES
((SELECT $node_id FROM Artist WHERE Name = 'Young Thug'), (SELECT $node_id FROM Artist WHERE Name = 'Travis Scott'), 'Song'),
((SELECT $node_id FROM Artist WHERE Name = 'Travis Scott'), (SELECT $node_id FROM Artist WHERE Name = 'Young Thug'), 'Song'); -- �������� ����� ��� �����������������, ���� �����

-- Travis Scott � Drake �� "SICKO MODE"
INSERT INTO CollaboratedWith ($from_id, $to_id, CollaborationType) VALUES
((SELECT $node_id FROM Artist WHERE Name = 'Travis Scott'), (SELECT $node_id FROM Artist WHERE Name = 'Drake'), 'Song'),
((SELECT $node_id FROM Artist WHERE Name = 'Drake'), (SELECT $node_id FROM Artist WHERE Name = 'Travis Scott'), 'Song');

-- Travis Scott � Playboi Carti �� "FE!N"
INSERT INTO CollaboratedWith ($from_id, $to_id, CollaborationType) VALUES
((SELECT $node_id FROM Artist WHERE Name = 'Travis Scott'), (SELECT $node_id FROM Artist WHERE Name = 'Playboi Carti'), 'Song'),
((SELECT $node_id FROM Artist WHERE Name = 'Playboi Carti'), (SELECT $node_id FROM Artist WHERE Name = 'Travis Scott'), 'Song');

-- Young Thug � Future ����� ������������ (��������, ������ "Super Slimey")
INSERT INTO CollaboratedWith ($from_id, $to_id, CollaborationType) VALUES
((SELECT $node_id FROM Artist WHERE Name = 'Young Thug'), (SELECT $node_id FROM Artist WHERE Name = 'Future'), 'Album/General'),
((SELECT $node_id FROM Artist WHERE Name = 'Future'), (SELECT $node_id FROM Artist WHERE Name = 'Young Thug'), 'Album/General');

--5. ��������� ������� MATCH, �������� �� ����� 5 ��������� �������� � ����������� �������� ���� ������.
-- ������ 1: ����� ��� ����� ����������� Young Thug
SELECT
    Artist.Name AS ArtistName,
    Song.Title AS SongTitle
FROM
    Artist, PerformedSong, Song
WHERE
    MATCH(Artist-(PerformedSong)->Song)
    AND Artist.Name = 'Young Thug'
    AND PerformedSong.Role = 'Main Artist';

	-- ������ 2: ����� ���� ������������, ������� ����������� ��� ����� (Featured Artist) �� ������ Travis Scott
SELECT
    MainArtist.Name AS MainArtistName,
    S.Title AS SongTitle,
    FeaturedArtist.Name AS FeaturedArtistName
FROM
    Artist AS MainArtist,
    PerformedSong AS MainPerformance,
    Song AS S,
    PerformedSong AS FeaturePerformance,
    Artist AS FeaturedArtist
WHERE
    MATCH(MainArtist-(MainPerformance)->S<-(FeaturePerformance)-FeaturedArtist)
    AND MainArtist.Name = 'Travis Scott'
    AND MainPerformance.Role = 'Main Artist'
    AND FeaturePerformance.Role = 'Featured Artist';

	-- ������ 3: ����� ��� �������, ���������� Future, � ����� �� ���� ��������
SELECT
    Ar.Name AS ArtistName,
    Al.Title AS AlbumTitle,
    S.Title AS SongTitle
FROM
    Artist Ar, ReleasedAlbum RA, Album Al, BelongsToAlbum BA, Song S
WHERE
    MATCH(Ar-(RA)->Al<-(BA)-S)
    AND Ar.Name = 'Future';

	-- ������ 4: ����� ������������, � �������� ����������� Travis Scott (�� ������ ����� CollaboratedWith)
SELECT
    A1.Name AS Artist1,
    A2.Name AS Artist2,
    CW.CollaborationType
FROM
    Artist A1, CollaboratedWith CW, Artist A2
WHERE
    MATCH(A1-(CW)->A2)
    AND A1.Name = 'Travis Scott';

	-- ������ 5: ����� ��� ����� �� ������� 'ASTROWORLD' � �� �������� ������������
SELECT
    Al.Title AS AlbumTitle,
    S.Title AS SongTitle,
    Ar.Name AS ArtistName
FROM
    Album Al, BelongsToAlbum BA, Song S, PerformedSong PS, Artist Ar
WHERE
    MATCH(Ar-(PS)->S-(BA)->Al)
    AND Al.Title = 'ASTROWORLD'
    AND PS.Role = 'Main Artist';

-- ������ 6: ����� ������������, ������� ��������� ������� � 2021 ����
SELECT
    Ar.Name AS ArtistName,
    Al.Title AS AlbumTitle,
    Al.ReleaseYear
FROM
    Artist Ar, ReleasedAlbum RA, Album Al
WHERE
    MATCH(Ar-(RA)->Al)
    AND Al.ReleaseYear = 2021;

--6. ��������� ������� SHORTEST_PATH, �������� �� ����� 2 ��������� �������� � ����������� �������� ���� ������ (����������� ��� ������ "+", ��� � "{1,n}").

--1. ����� ���� ��������� �������� � Young Thug ����� ��������������
SELECT 
    Artist1.Name AS ArtistName,
    STRING_AGG(Artist2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS CollaborationPath
FROM 
    Artist AS Artist1,
    CollaboratedWith FOR PATH AS cw,
    Artist FOR PATH AS Artist2
WHERE 
    MATCH(SHORTEST_PATH(Artist1(-(cw)->Artist2)+))
    AND Artist1.Name = 'Young Thug';

--2. ����� ���� �� Travis Scott � ������ �������� ����� ���������� �����
SELECT 
    Artist1.Name AS ArtistName,
    STRING_AGG(Artist2.Name + ' (' + Song.Title + ')', ' -> ') WITHIN GROUP (GRAPH PATH) AS SongConnections
FROM 
    Artist AS Artist1,
    PerformedSong FOR PATH AS ps,
    Song FOR PATH AS Song,
    PerformedSong FOR PATH AS ps2,
    Artist FOR PATH AS Artist2
WHERE 
    MATCH(SHORTEST_PATH(Artist1(-(ps)->Song<-(ps2)-Artist2){1,2}))
    AND Artist1.Name = 'Travis Scott';

