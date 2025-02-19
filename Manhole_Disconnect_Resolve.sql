SELECT 
    d.device AS Device,
    s.location AS Location,
    CONCAT(GREATEST(0, s.manhole_distance - s.offset_ultra_level - d.Level), ' cm') AS Level,
    DATE_FORMAT(d.timestamp, '%Y-%m-%d %H:%i:%s') AS Timestamp,
    DATE_FORMAT(prev.timestamp, '%Y-%m-%d %H:%i:%s') AS Prev_Timestamp,  
    CASE
        WHEN d.Level2 > s.cover_setup THEN 'ฝาท่อเปิด'
        WHEN d.Level2 = 0 THEN 'ฝาท่อเปิด'
        ELSE 'ฝาท่อปิด'
    END AS Cover_Status,
    CONCAT(
        CASE 
            WHEN d.Counter >= 26280 THEN 0
            WHEN d.Counter <= 0 THEN 100
            ELSE ROUND((1 - (d.Counter / 26280)) * 100,1)
        END, ' %'
    ) AS Battery_Percentage,
    CASE
        WHEN prev.timestamp IS NULL THEN 0  -- ถ้าไม่มีข้อมูลก่อนหน้า ถือว่าออนไลน์
        WHEN TIMESTAMPDIFF(MINUTE, prev.timestamp, d.timestamp) > 120 
            AND TIMESTAMPDIFF(MINUTE, d.timestamp, NOW()) < 60 THEN 1  -- ต้องการให้ Resolve ส่งแจ้งเตือนครั้งเดียว หากเกิน 60 นาทีจากปัจจุบันจะหยุดการแจ้งเตือน
        ELSE 0
    END AS "Device Status"
FROM 
    mpete_manhole.data d
LEFT JOIN 
    (SELECT device, timestamp 
     FROM mpete_manhole.data) prev 
    ON d.device = prev.device 
    AND prev.timestamp = (
        SELECT MAX(d2.timestamp)
        FROM mpete_manhole.data d2
        WHERE d2.device = d.device AND d2.timestamp < d.timestamp
    )
JOIN 
    mpete_manhole.setup s ON d.device = s.device
WHERE 
    d.timestamp = (
        SELECT MAX(d2.timestamp)
        FROM mpete_manhole.data d2
        WHERE d2.device = d.device
    );
