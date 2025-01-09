SELECT 
    d.device AS Device,
    s.location AS Location,
    s.latitude AS Latitude,
    s.longitude AS Longitude,
    s.manhole_distance AS "Manhole Distance",
    (s.manhole_distance * (s.alert_decis/100)) AS "[Line Notify] Water Level Alert",
    GREATEST(0, (s.manhole_distance - s.offset_ultra_level - d.level)) AS "Water Level",
    
    -- ตรวจสอบสถานะฝาปิด
    CASE
        WHEN d.cover = 1 THEN 'OPEN !'
        WHEN d.cover = 0 THEN 'Normal'
        ELSE 'Unknown'
    END AS "Cover Status",

    -- แจ้งเตือนเมื่อสถานะเชื่อมต่อเป็น Connected และมีเงื่อนไขการแจ้งเตือนอื่น ๆ
    CASE
        WHEN NOW() - INTERVAL 2 HOUR > d.timestamp THEN 3 -- Disconnected: ไม่แจ้งเตือน
        WHEN d.cover = 1 THEN 2 -- ฝาท่อเปิด
        WHEN (s.manhole_distance - s.offset_ultra_level - d.level) >= (s.manhole_distance * (s.alert_decis/100)) THEN 1 -- น้ำเกิน
        ELSE 0
    END AS "Manhole Alert",


    d.timestamp AS Timestamp
FROM mpete_manhole.data d
JOIN mpete_manhole.setup s
    ON d.device = s.device
WHERE d.timestamp = (
    -- เลือก timestamp ล่าสุดของแต่ละ device
    SELECT MAX(d2.timestamp)
    FROM mpete_manhole.data d2
    WHERE d2.device = d.device
)
ORDER BY d.device ASC;
