SELECT 
    ROW_NUMBER() OVER (ORDER BY d.device ASC) AS `No.`,
    d.device AS Device,

    CONCAT(
        '💧 ', 
        GREATEST(0, (s.manhole_distance - s.offset_ultra_level - d.level)),
        ' cm'
    ) AS "Water Level",

    CASE
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Status",

    CASE
            WHEN d.Level2 > s.cover_setup THEN 1
            WHEN d.Level2 =0 THEN 1
            ELSE 0
    END AS "Cover Status",
    s.location AS Location,
    s.latitude AS Latitude,
    s.longitude AS Longitude,
    s.manhole_distance AS "Manhole Distance",
    CONCAT(
        s.Low_Level, 
        ' % (', 
        ROUND(s.manhole_distance * (s.Low_Level / 100), 2), 
        ' cm)'
    ) AS "Water Level Alert",
    d.level AS "Ultrasonic Level (Not Water)",
    d.timestamp AS Timestamp
FROM mpete_manhole.data d
JOIN mpete_manhole.setup s
    ON d.device = s.device
WHERE d.timestamp = (
    SELECT MAX(d2.timestamp)
    FROM mpete_manhole.data d2
    WHERE d2.device = d.device
)
ORDER BY d.device ASC;
