/* Table Views */
select * from hosurclinics;
select * from hosurhomes;
select * from hosurhospitals;
select * from hosurschools;


/* Query to update House Names where NULL */

UPDATE hosurhomes
SET name = 'House_' || gid
WHERE name IS NULL;



/* Basic Analysis */

/*School counts within 5Km radius of homes*/

SELECT
    h.name AS home_name,
    COUNT(s.*) AS school_count
FROM hosurhomes h
LEFT JOIN hosurschools s
ON ST_DWithin(
     ST_Transform(h.geom, 3857),
     ST_Transform(s.geom, 3857),
     5000
   )
WHERE h.name IS NOT NULL
GROUP BY h.name
ORDER BY h.name;



/*Hospital counts within 5Km radius of homes*/
SELECT
    h.name AS home_name,
    COUNT(hp.*) AS hospital_count
FROM hosurhomes h
LEFT JOIN hosurhospitals hp
ON ST_DWithin(
     ST_Transform(h.geom, 3857),
     ST_Transform(hp.geom, 3857),
     5000
   )
GROUP BY h.name
ORDER BY h.name;


/*Clinic counts within 5Km radius of homes*/
SELECT
    h.name AS home_name,
    COUNT(c.*) AS clinic_count
FROM hosurhomes h
LEFT JOIN hosurclinics c
ON ST_DWithin(
     ST_Transform(h.geom, 3857),
     ST_Transform(c.geom, 3857),
     2000
   )
GROUP BY h.name
ORDER BY h.name;


/* Nearest Hospital to Each Home */

SELECT DISTINCT ON (h.name)
    h.name AS home_name,
    hp.name AS hospital_name,
    ST_Distance(
        ST_Transform(h.geom, 3857),
        ST_Transform(hp.geom, 3857)
    ) AS distance_m
FROM hosurhomes h
JOIN hosurhospitals hp
ON TRUE
ORDER BY h.name, distance_m;


/* Project Map-Focused main Analysis */

/* ANALYSIS 1 — Underserved Homes (No Hospital Within 5 Km) */

CREATE OR REPLACE VIEW underserved_homes AS
SELECT
    h.name AS home_name,
    h.geom
FROM hosurhomes h
WHERE h.name IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM hosurhospitals hp
    WHERE ST_DWithin(
        ST_Transform(h.geom, 3857),
        ST_Transform(hp.geom, 3857),
        5000
    )
);
/* Buffer created in QGIS */


/*ANALYSIS 2 — Nearest Healthcare (Hospital + Clinic)*/

CREATE OR REPLACE VIEW Nearest_Healthcare AS
SELECT DISTINCT ON (h.name)
    h.name AS home_name,
    ST_Distance(
        ST_Transform(h.geom, 3857),
        ST_Transform(hc.geom, 3857)
    ) AS distance_m,
    h.geom
FROM hosurhomes h
JOIN (
    SELECT geom FROM hosurhospitals
    UNION ALL
    SELECT geom FROM hosurclinics
) hc
ON h.name IS NOT NULL
ORDER BY h.name, distance_m;


/*ANALYSIS 3 — Education-Healthcare Service Imbalance*/

CREATE OR REPLACE VIEW service_imbalance AS
SELECT
    h.name AS home_name,
    COUNT(DISTINCT s.*) AS schools_3km,
    COUNT(DISTINCT hp.*) AS hospitals_3km,
    (COUNT(DISTINCT s.*) - COUNT(DISTINCT hp.*)) AS imbalance_score,
    h.geom
FROM hosurhomes h
LEFT JOIN hosurschools s
ON ST_DWithin(
    ST_Transform(h.geom, 3857),
    ST_Transform(s.geom, 3857),
    3000
)
LEFT JOIN hosurhospitals hp
ON ST_DWithin(
    ST_Transform(h.geom, 3857),
    ST_Transform(hp.geom, 3857),
    3000
)
WHERE h.name IS NOT NULL
GROUP BY h.name, h.geom;
