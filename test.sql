INSERT INTO customer (name, address, city, state, zip)
    VALUES('fred Flinstone', '123 Cobblestone Way', 'Bedrock', 'CA', '9234');
    
UPDATE customer 
SET address = '123 Nowhereway', zip='2313213' 
WHERE id=4;

SELECT s.id AS sale, i.name, s.price
FROM sale AS s
JOIN item AS i ON s.item_id = i.id;

--test database
SELECT * 
FROM customer;

CREATE TABLE Test (
    a INTEGER,
    b INT
);

INSERT INTO Test VALUES(1, 1);
INSERT INTO Test VALUES(2, 1);
INSERT INTO Test VALUES(3, 1);
INSERT INTO Test VALUES(4, 1);
INSERT INTO Test VALUES(5, 2);
INSERT INTO Test VALUES(1, 2);
INSERT INTO Test VALUES(2, 2);

SELECT DISTINCT a, b from Test;
SELECT a, b from Test;


ALTER TABLE Test ADD d TEXT;

INSERT INTO Test VALUES(NULL, "hello", "bye");
INSERT INTO Test SELECT id, name, description FROM item;

SELECT * FROM Test;

DROP TABLE TEST;

--if statements
CREATE TABLE BoolTest (
    a INTEGER,
    b INTEGER
);

INSERT INTO BoolTest VALUES (0, 1);

--if statements
SELECT
    CASE WHEN a THEN 'true' ELSE 'false' END AS A,
    CASE WHEN b THEN 'true' ELSE 'false' END AS B
    FROM BoolTest;
    


CREATE TABLE left ( id INTEGER, description TEXT );
CREATE TABLE right ( id INTEGER, description TEXT );

DROP TABLE left;
DROP TABLE right;

INSERT INTO left VALUES ( 1, 'left 01' );
INSERT INTO left VALUES ( 2, 'left 02' );
INSERT INTO left VALUES ( 3, 'left 03' );
INSERT INTO left VALUES ( 4, 'left 04' );
INSERT INTO left VALUES ( 5, 'left 05' );
INSERT INTO left VALUES ( 6, 'left 06' );
INSERT INTO left VALUES ( 7, 'left 07' );
INSERT INTO left VALUES ( 8, 'left 08' );
INSERT INTO left VALUES ( 9, 'left 09' );

INSERT INTO right VALUES ( 6, 'right 06' );
INSERT INTO right VALUES ( 7, 'right 07' );
INSERT INTO right VALUES ( 8, 'right 08' );
INSERT INTO right VALUES ( 9, 'right 09' );
INSERT INTO right VALUES ( 10, 'right 10' );
INSERT INTO right VALUES ( 11, 'right 11' );
INSERT INTO right VALUES ( 11, 'right 12' );
INSERT INTO right VALUES ( 11, 'right 13' );
INSERT INTO right VALUES ( 11, 'right 14' );

SELECT *
FROM LEFT;

SELECT *
FROM RIGHT;

-- inner join
SELECT l.description AS left, r.description AS right
FROM left as l
LEFT JOIN right AS r ON l.id = r.id;


-- transactions
BEGIN TRANSACTION;

CREATE TABLE TEST(
    ID INTEGER PRIMARY KEY,
    Data TEXT
);

INSERT INTO TEST (Data)
    VALUES('some test');

INSERT INTO TEST (Data)
    VALUES('some test');
    
INSERT INTO TEST (Data)
    VALUES('some test'); 


END TRANSACTION;

-- trigger
CREATE TABLE WidgetCustomer (
    ID INTEGER PRIMARY KEY,
    Name Text,
    LastOrderID INTEGER
);

CREATE TABLE WidgetSale (
    ID INTEGER PRIMARY KEY,
    ItemID INTEGER,
    CustomerID INTEGER,
    Quan INTEGER,
    Price INTEGER,
    Reconciled INTEGER
);

DROP TABLE IF EXISTS WidgetSale;

INSERT INTO WidgetCustomer (Name) VALUES ('Bob');
INSERT INTO WidgetCustomer (Name) VALUES ('Sally');
INSERT INTO WidgetCustomer (Name) VALUES ('Fred');



INSERT INTO WidgetSale (ItemID, CustomerID, Quan, Price, Reconciled)
    VALUES (1, 3, 5, 1995, 0);

INSERT INTO WidgetSale (ItemID, CustomerID, Quan, Price, Reconciled)
    VALUES (2, 1, 1, 1095, 1);
    
INSERT INTO WidgetSale (ItemID, CustomerID, Quan, Price, Reconciled)
    VALUES (3, 2, 10, 1195, 0);
    


SELECT * FROM WidgetCustomer;

-- trigger is like event listener
CREATE TRIGGER NewWidgetSale AFTER INSERT ON WidgetSale
    BEGIN -- this says what to do after an insertion is done in WidgetSale
        UPDATE WidgetCustomer SET LastOrderID = NEW.ID WHERE WidgetCustomer.ID = NEW.CustomerID;
    END -- i am guessin NEW keyword refers to WidgetSale table
;

-- a trigger which prevents an update on a row in table
CREATE TRIGGER NewWidgetSale BEFORE UPDATE ON WidgetSale 
    BEGIN 
        SELECT RAISE(ROLLBACK, 'cannot update table "WidgetSale"') FROM WidgetSale
            WHERE ID=NEW.ID AND Reconciled = 1;
    END 
;

INSERT INTO WidgetSale (ItemID, CustomerID, Quan, Price)
    VALUES (1, 3, 5, 1995);

INSERT INTO WidgetSale (ItemID, CustomerID, Quan, Price)
    VALUES (2, 1, 1, 1095);
    
INSERT INTO WidgetSale (ItemID, CustomerID, Quan, Price)
    VALUES (3, 2, 10, 1195);
    




-- world db
SELECT * FROM Country
WHERE Population < 100000 AND Continent = 'Oceania'
ORDER BY Population DESC;

SELECT Name, Continent, Population FROM Country
WHERE Name LIKE '%island' 
ORDER BY Name;

SELECT NAME, CONTINENT from Country
ORDER BY Name;

SELECT REGION, COUNT(*) AS Count
FROM Country
GROUP BY Region
ORDER BY Count DESC;

--length 
SELECT Name, LENGTH(Name) AS Len
FROM City
ORDER BY Len DESC, Name;

--substring
SELECT SUBSTR('hello world', 7, 2);

--trim
SELECT TRIM('   HELLO     ') AS trimmed;
SELECT RTRIM('                    HELLO     ') AS trimmed;
SELECT LTRIM('   HELLO                 ') AS trimmed;
SELECT TRIM('                     HELLO                ', ' ') AS trimmed;

--uppercase/lowercase
SELECT LOWER(Name)
FROM City
ORDER BY Name;

SELECT UPPER(Name)
FROM City
ORDER BY Name;

--distinct with aggregrate functions
SELECT COUNT(DISTINCT HeadOfState)
FROM Country;

-- subselect
CREATE TABLE T (a TEXT, b TEXT);

INSERT INTO T VALUES ('NY0123', 'US4567');
INSERT INTO T VALUES ('AZ9437', 'GB1234');
INSERT INTO T VALUES ('CA1279', 'FR5678');

SELECT co.Name, ss.CCode
FROM (SELECT SUBSTR(a, 1, 2) AS State, SUBSTR(a, 3) AS SCode,
        SUBSTR(b, 1, 2) AS Country, SUBSTR(b, 3) AS CCode
    FROM T
    ) AS ss
    JOIN Country AS co
        ON co.Code2 = ss.Country
;


-- album db
SELECT a.title AS Album, COUNT(t.track_number) AS Tracks
FROM track AS t
JOIN album AS a
    ON a.id = t.album_id
GROUP BY a.id
HAVING Tracks >= 10 --HAVING is like WHERE clause for aggregate data (as in, the data generated by aggregrate functions, in this case it is COUNT)
ORDER BY Tracks DESC, Album;

-- view
CREATE VIEW trackView AS
    SELECT id, album_id, title, track_number, duration / 60 AS m, duration % 60 AS s FROM track;
    
-- drop view
DROP VIEW IF EXISTS trackView;

SELECT a.title AS album, a.artist, t.track_number AS seq, t.title, t.m, t.s
    FROM album AS a
    JOIN trackView AS t
        ON t.album_id = a.id
    ORDER BY a.title, t.track_number
;

-- joined view
CREATE VIEW joinedAlbum AS
    SELECT a.artist AS artist, a.title AS album, t.title AS track,
    t.track_number AS trackno, t.duration / 60 AS m, t.duration % 60 AS s
    FROM track AS t
        JOIN album AS a
            ON a.id = t.album_id
;

-- simple trick for duration -- ' || ' is for concatenating, not an OR operator
SELECT artist, album, track, trackno,
m || ':' || substr('00' || s, -2, 2) AS duration
FROM joinedAlbum;

-- random
SELECT TYPEOF(1 + 1);
SELECT TYPEOF(1 + 1.0);
SELECT TYPEOF('panda');
SELECT TYPEOF('panda' + 'koala');

SELECT ROUND(2.666, 0); --could be used for sf instead of dp


--Date
SELECT DATETIME('now') AS datetime;
