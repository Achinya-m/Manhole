SELECT 
    ROW_NUMBER() OVER (ORDER BY d.device ASC) AS `No.`,
    d.device AS Device,
    s.location AS Location,
    s.latitude AS Latitude,
    s.longitude AS Longitude,
    s.offset_ultra_level,
    s.Low_Level,
    s.Medium_Level,
    s.High_Level,
    s.manhole_distance,
    (s.manhole_distance * (s.Low_Level/100)) AS "Low_Level_CM", -- Low_Level_CM of s.manhole_distance
    (s.manhole_distance * (s.Medium_Level/100)) AS "Medium_Level_CM", -- Medium_Level_CM of s.manhole_distance
    (s.manhole_distance * (s.High_Level/100)) AS "High_Level_CM",  -- High_Level_CM of s.manhole_distance
    d.Level AS "Ultrasonic Level",
    GREATEST(0, (s.manhole_distance - s.offset_ultra_level - d.level)) AS "Water Level",
    
    CASE
            WHEN d.Level2 > s.cover_setup THEN 1
            WHEN d.Level2 =0 THEN 1
            ELSE 0
    END AS "Cover Status",
    d.timestamp AS Timestamp,
    
    -- Water Level Variable 1 
    CASE
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.01 * s.manhole_distance) THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 1",

    -- Water Level Variable 2
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.10 * s.manhole_distance)  THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 2",

    -- Water Level Variable 3
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.20 * s.manhole_distance) THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 3",

    -- Water Level Variable 4
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.30 * s.manhole_distance)  THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 4",

    -- Water Level Variable 5
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.475 * s.manhole_distance)  THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 5",

    -- Water Level Variable 6
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.65 * s.manhole_distance) THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 6",

    -- Water Level Variable 7
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= (0.825 * s.manhole_distance)  THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 0
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 4
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 3
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 2
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 1
        ELSE 0
    END AS "Water Level Variable 7"
    
FROM mpete_manhole.data d
JOIN mpete_manhole.setup s
    ON d.device = s.device
WHERE d.timestamp = (
    SELECT MAX(d2.timestamp)
    FROM mpete_manhole.data d2
    WHERE d2.device = d.device
)
AND d.device IN ('$Device')
ORDER BY d.device DESC
LIMIT 1;
