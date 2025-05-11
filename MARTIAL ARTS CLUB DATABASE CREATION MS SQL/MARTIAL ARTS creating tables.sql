CREATE TABLE MARTIAL_ARTS_NAMES (
    martial_art_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ma_name VARCHAR(100) UNIQUE NOT NULL,
    origin_country VARCHAR(100) DEFAULT 'China'
);

INSERT INTO MARTIAL_ARTS_NAMES (ma_name, origin_country) VALUES 
    ('Wing Chun', 'China'),
    ('Choy Lai Fut', 'China'),
    ('Brasilian Jiu Jitsu', 'Brasil'),
    ('Sambo', 'Russia'),
    ('Krav Maga', 'Israel'),
    ('Muay Thai', 'Thailand');

SELECT * FROM MARTIAL_ARTS_NAMES;

CREATE TABLE MARTIAL_ARTS_PERFORMANCES (
	martial_art_ID int not null,
	clinching int CHECK (clinching>=1 AND clinching<=10),
	full_hand_punching int CHECK (full_hand_punching>=1 AND full_hand_punching<=10),
	legs int CHECK (legs>=1 AND legs<=10),
	throws int CHECK(throws>=1 AND throws<=10),
	ground_work int CHECK(ground_work>=1 AND ground_work<=10),
	vital_points_punching int CHECK(vital_points_punching>=1 AND vital_points_punching <=10),
	FOREIGN KEY (martial_art_ID) REFERENCES MARTIAL_ARTS_NAMES(martial_art_ID)
	)


INSERT INTO MARTIAL_ARTS_PERFORMANCES VALUES 
    (1, 10, 5, 5, 3, 1, 10),
    (2, 5, 8, 8, 8, 1, 10),
    (3, 7, 3, 3, 10, 10, 1),
    (4, 7, 6, 6, 10, 8, 1),
    (5, 5, 5, 5, 5, 5, 5),
    (6, 10, 8, 9, 4, 1, 1);

SELECT * FROM MARTIAL_ARTS_PERFORMANCES

SELECT 
	martial_art_ID, 
	((clinching + full_hand_punching + legs + throws + ground_work + vital_points_punching) / 6) AS average_score
FROM MARTIAL_ARTS_PERFORMANCES

ALTER TABLE MARTIAL_ARTS_PERFORMANCES
ADD average_score AS ((clinching + full_hand_punching + legs + throws + ground_work + vital_points_punching) / 6.0);
 
SELECT * FROM MARTIAL_ARTS_PERFORMANCES

UPDATE MARTIAL_ARTS_PERFORMANCES
SET throws = 3
WHERE martial_art_ID = 2

SELECT ma_name, clinching, full_hand_punching, legs, throws, ground_work, vital_points_punching, ((clinching + full_hand_punching + legs + throws + ground_work + vital_points_punching) / 6.0) as average_score 
FROM MARTIAL_ARTS_NAMES as man
INNER JOIN MARTIAL_ARTS_PERFORMANCES as map ON man.martial_art_ID = map.martial_art_ID
WHERE ((clinching + full_hand_punching + legs + throws + ground_work + vital_points_punching) / 6.0)  >=  5.5



