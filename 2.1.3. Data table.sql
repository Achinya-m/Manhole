SELECT 
    ROW_NUMBER() OVER (ORDER BY d.device ASC) AS `No.`,
    d.device AS Device,
    GREATEST(0, (s.manhole_distance - s.offset_ultra_level - d.level)) AS "Water Level",
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (s.manhole_distance * (s.Medium_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (s.manhole_distance * (s.High_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) > (s.manhole_distance * (s.High_Level / 100)) THEN 4
        ELSE 0
    END AS "Water Level Status",
    d.cover AS "Cover Status",
    s.location AS Location,
    s.latitude AS Latitude,
    s.longitude AS Longitude,
    s.manhole_distance AS "Manhole Distance",
    s.alert_decis AS "Water Level Alert Decision",
    d.level AS "Ultrasonic Level",
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
