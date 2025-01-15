SELECT 
    d.device AS device_data,
    d.cover AS "Value",
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
