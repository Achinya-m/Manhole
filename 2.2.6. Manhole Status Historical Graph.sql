SELECT 
    d.device AS device_data,
    -- d.cover AS "Value",
    CASE
            WHEN d.Level2 > s.cover_setup THEN 1
            WHEN d.Level2 =0 THEN 1
            ELSE 0
    END AS "Value",
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
