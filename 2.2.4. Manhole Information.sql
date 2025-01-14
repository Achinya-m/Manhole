SELECT 
    s.device AS Device,
    s.location AS Location,
    s.latitude AS Latitude,
    s.longitude AS Longitude,
    s.manhole_distance,
    s.commu,
    s.commu_id,
    d.Counter,
    d.Level AS "Ultrasonic Level",
    (s.manhole_distance - d.level) AS "Water Level",
    d.Cover AS "Cover Status",

    -- Mapping เปอร์เซ็นต์แบตเตอรี่จาก Counter
    CASE 
        WHEN d.Counter >= 26280 THEN 0
        WHEN d.Counter <= 0 THEN 100
        ELSE ROUND((1 - (d.Counter / 26280)) * 100,1)
    END AS "Battery Percentage",

    d.Commu,

    -- ปรับ CASE โดยแปลงค่า 99 และ 119 ให้เป็น 0
    CASE 
        WHEN d.Commu IN (99, 119) THEN 0 
        WHEN d.Commu >= 2 THEN 1 
        ELSE 0 
    END AS "Commu 1",

    CASE 
        WHEN d.Commu IN (99, 119) THEN 0 
        WHEN d.Commu >= 5 THEN 1 
        ELSE 0 
    END AS "Commu 2",

    CASE 
        WHEN d.Commu IN (99, 119) THEN 0 
        WHEN d.Commu >= 10 THEN 1 
        ELSE 0 
    END AS "Commu 3",

    CASE 
        WHEN d.Commu IN (99, 119) THEN 0 
        WHEN d.Commu >= 15 THEN 1 
        ELSE 0 
    END AS "Commu 4",

    CASE 
        WHEN d.Commu IN (99, 119) THEN 0 
        WHEN d.Commu >= 20 THEN 1 
        ELSE 0 
    END AS "Commu 5",

    CASE 
        WHEN d.Commu IN (99, 119) THEN 0 
        WHEN d.Commu >= 25 THEN 1 
        ELSE 0 
    END AS "Commu 6",

    d.timestamp AS Timestamp,

    -- ฟังก์ชัน Connected / Disconnected
    CASE 
        WHEN NOW() - INTERVAL 2 HOUR <= d.timestamp THEN 'Connected'
        ELSE 'Disconnected'
    END AS "Connection Status"
    
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
