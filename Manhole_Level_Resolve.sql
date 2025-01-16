SELECT 
    d.device AS Device,
    s.location AS Location,
    CONCAT(GREATEST(0, s.manhole_distance - s.offset_ultra_level - d.Level), ' cm') AS Level,
    DATE_FORMAT(d.timestamp, '%Y-%m-%d %H:%i:%s') AS Timestamp,
    CASE
        WHEN d.Cover = 0 THEN 'ฝาท่อปิด'
        WHEN d.Cover = 1 THEN 'ฝาท่อเปิด'
        ELSE 'ไม่ทราบสถานะ'
    END AS Cover_Status,
    CONCAT(
        CASE 
            WHEN d.Counter >= 26280 THEN 0
            WHEN d.Counter <= 0 THEN 100
            ELSE ROUND((1 - (d.Counter / 26280)) * 100, 1)
        END, ' %'
    ) AS Battery_Percentage,
    CASE
        WHEN (
            SELECT 
                GREATEST(0, s.manhole_distance - s.offset_ultra_level - d_prev.Level - (s.manhole_distance * (s.alert_decis / 100)))
            FROM 
                mpete_manhole.data d_prev
            WHERE 
                d_prev.device = d.device AND 
                d_prev.timestamp = (
                    SELECT MAX(d2.timestamp)
                    FROM mpete_manhole.data d2
                    WHERE d2.device = d.device AND d2.timestamp < d.timestamp
                )
        ) > 0
        AND GREATEST(0, s.manhole_distance - s.offset_ultra_level - d.Level - (s.manhole_distance * (s.alert_decis / 100))) <= 0
        THEN 1
        ELSE 0
    END AS Resolve_Water_Level
FROM 
    mpete_manhole.data d
JOIN 
    mpete_manhole.setup s ON d.device = s.device
WHERE 
    d.timestamp = (
        SELECT MAX(d2.timestamp)
        FROM mpete_manhole.data d2
        WHERE d2.device = d.device
    );
