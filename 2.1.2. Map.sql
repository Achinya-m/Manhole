SELECT 
    -- แจ้งเตือนเมื่อสถานะเชื่อมต่อเป็น Connected และมีเงื่อนไขการแจ้งเตือนอื่น ๆ
    CASE
        WHEN NOW() - INTERVAL 2 HOUR > d.timestamp THEN 3 -- Disconnected: ไม่แจ้งเตือน
        WHEN d.Level2 > s.cover_setup THEN 2 -- ฝาท่อเปิด
        WHEN d.Level2 = 0 THEN 2  -- ฝาท่อเปิด
        WHEN (s.manhole_distance - s.offset_ultra_level - d.level) >= (s.manhole_distance * (s.Low_level/100)) THEN 1 -- น้ำเกิน
        ELSE 0
    END AS "Manhole Alert",
    
    d.device AS Device,
    s.location AS Location,
    s.latitude AS Latitude,
    s.longitude AS Longitude,
    s.manhole_distance AS "Manhole Distance",
    CONCAT(
        s.Low_level, 
        ' % (', 
        ROUND(s.manhole_distance * (s.Low_level / 100), 1), 
        ' cm)'
    ) AS "[Line Notify] Water Level Alert",


    CONCAT(
        FORMAT(GREATEST(0, (s.manhole_distance - s.offset_ultra_level - d.level)), 2), 
        ' cm [ ', 
        CASE
            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 'Empty'
            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 'High Level'
            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 'Medium Level'
            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 'Low Level'
            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 'Near Empty'
            ELSE 'Empty'
        END, 
        ' ]'
    ) AS "Water Level",
    
    -- ตรวจสอบสถานะฝาปิด
    /*
    CASE
        WHEN d.cover = 1 THEN 'OPEN !'
        WHEN d.cover = 0 THEN 'Normal'
        ELSE 'Unknown'
    END AS "Cover Status",
    */
    CASE
        WHEN d.Level2 > s.cover_setup THEN 'OPEN !'
        WHEN d.Level2 = 0 THEN 'OPEN !'
        ELSE 'Close'
    END AS "Cover Status",

    CASE 
        WHEN cover_ack = 1 THEN '🔕 Disable Line Notify [Cover Status]'
        ELSE '🔔 Enable Line Notify'
    END AS "Manhole Cover Acknowledge",
    CASE 
        WHEN maintenance = 1 THEN '🔕 Disable Line Notify [Cover Status and Level Status]'
        ELSE '🔔 Enable Line Notify'
    END AS "Manhole Maintenance ⚠️",

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
