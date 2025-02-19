SELECT 
    d.device AS Device,
    s.location AS Location,
    CONCAT(
        CASE 
            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < 0 THEN 0
            ELSE (s.manhole_distance - s.offset_ultra_level - d.Level)
        END, ' cm'
    ) AS Level,
    DATE_FORMAT(d.timestamp, '%Y-%m-%d %H:%i:%s') AS Timestamp,
    CASE
        WHEN d.Level2 > s.cover_setup THEN 'ฝาท่อเปิด'
        WHEN d.Level2 = 0 THEN 'ฝาท่อเปิด'
        ELSE 'ฝาท่อปิด'
    END AS Cover_Status,
    CONCAT(
    -- Mapping เปอร์เซ็นต์แบตเตอรี่จาก Counter โดย ส่งทุกๆ 1 ชม. และแบตเตอรี่=0 เมื่อครบ 3 ปี : 24x365x3=26280
    CASE 
        WHEN d.Counter >= 26280 THEN 0
        WHEN d.Counter <= 0 THEN 100
        ELSE ROUND((1 - (d.Counter / 26280)) * 100,1)
    END, ' %'
    ) AS Battery_Percentage,
    CASE
        WHEN 
            prev_d.Level2 > s.cover_setup 
            AND d.Level2 < s.cover_setup
            AND s.cover_ack = 0 
            And s.maintenance = 0 
            AND TIMESTAMPDIFF(MINUTE, d.timestamp, NOW()) < 60 -- ต้องการให้ Resolve ส่งแจ้งเตือนครั้งเดียว หากเกิน 60 นาทีจากปัจจุบันจะหยุดการแจ้งเตือน
        THEN 1
        WHEN 
            prev_d.Level2 = 0 
            AND d.Level2 > 0 
            AND d.Level2 < s.cover_setup 
            AND s.cover_ack = 0 
            And s.maintenance = 0 
            AND TIMESTAMPDIFF(MINUTE, d.timestamp, NOW()) < 60 -- ต้องการให้ Resolve ส่งแจ้งเตือนครั้งเดียว หากเกิน 60 นาทีจากปัจจุบันจะหยุดการแจ้งเตือน
        THEN 1  
        ELSE 0
    END AS Resolve_Cover
FROM mpete_manhole.data d
JOIN mpete_manhole.setup s
    ON d.device = s.device
LEFT JOIN mpete_manhole.data prev_d
    ON d.device = prev_d.device
    AND prev_d.timestamp = (
        SELECT MAX(d2.timestamp)
        FROM mpete_manhole.data d2
        WHERE d2.device = d.device
        AND d2.timestamp < d.timestamp
    )
WHERE d.timestamp = (
    SELECT MAX(d2.timestamp)
    FROM mpete_manhole.data d2
    WHERE d2.device = d.device
)
