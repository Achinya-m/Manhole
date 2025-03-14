SELECT 
    d.device AS Device,
    s.location AS Location,
    d.Counter,
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
        CASE 
            WHEN d.Counter >= 26280 THEN 0
            WHEN d.Counter <= 0 THEN 100
            ELSE ROUND((1 - (d.Counter / 26280)) * 100, 1)
        END, ' %'
    ) AS Battery_Percentage_Status,

    -- Mapping เปอร์เซ็นต์แบตเตอรี่จาก Counter โดย ส่งทุกๆ 1 ชม. และแบตเตอรี่=0 เมื่อครบ 3 ปี : 24x365x3=26280
    CASE 
        WHEN d.Counter >= 26280 THEN 0
        WHEN d.Counter <= 0 THEN 100
        ELSE ROUND((1 - (d.Counter / 26280)) * 100,1)
    END AS Battery_Percentage

FROM mpete_manhole.data d
JOIN mpete_manhole.setup s
    ON d.device = s.device
WHERE d.timestamp = (
    SELECT MAX(d2.timestamp)
    FROM mpete_manhole.data d2
    WHERE d2.device = d.device
);
