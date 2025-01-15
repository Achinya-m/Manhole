SELECT 
    d.device AS device_data,
    CASE 
        WHEN (s.manhole_distance - s.offset_ultra_level - d.level) < 0 THEN 0
        ELSE (s.manhole_distance - s.offset_ultra_level - d.level)
    END AS "value",
    d.timestamp AS "time"
FROM 
    mpete_manhole.data d
JOIN 
    mpete_manhole.setup s ON d.device = s.device
WHERE 
    d.device IN ('$Device')
ORDER BY 
    d.timestamp ASC
LIMIT 10000;
