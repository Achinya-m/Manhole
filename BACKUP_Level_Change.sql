SELECT 
    d.device AS Device,
    s.location AS Location,
    CONCAT(GREATEST(0, s.manhole_distance - s.offset_ultra_level - d.Level), ' cm') AS Level,
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
    ) AS Battery_Percentage,

    -- Current Level
    CASE
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 'Empty'
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 'High Level'
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 'Medium Level'
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 'Low Level'
        WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 'Near Empty'
        ELSE 'Empty'
    END AS Current_Level,

    -- Previous Level
    CASE
        WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) <= 0 THEN 'Empty'
        WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * (s.High_Level / 100)) THEN 'High Level'
        WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * (s.Medium_Level / 100)) THEN 'Medium Level'
        WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * (s.Low_Level / 100)) THEN 'Low Level'
        WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) < (s.manhole_distance * (s.Low_Level / 100)) THEN 'Near Empty'
        ELSE 'Empty'
    END AS Previous_Level,

    -- Level Change Alert
    CASE
        WHEN s.maintenance = 1 THEN 0
        ELSE 
            CASE
                WHEN 
                (
                    (
                        (CASE
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 'Empty'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * ((s.High_Level + 1) / 100)) THEN 'High Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * ((s.Medium_Level + 1) / 100)) THEN 'Medium Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * ((s.Low_Level + 1) / 100)) THEN 'Low Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * ((s.Low_Level + 1) / 100)) THEN 'Near Empty'
                            ELSE 'Empty'
                        END) != 
                        (CASE
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) <= 0 THEN 'Empty'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * ((s.High_Level + 1) / 100)) THEN 'High Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * ((s.Medium_Level + 1) / 100)) THEN 'Medium Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * ((s.Low_Level + 1) / 100)) THEN 'Low Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) < (s.manhole_distance * ((s.Low_Level + 1) / 100)) THEN 'Near Empty'
                            ELSE 'Empty'
                        END)
                    )
                OR
                    (
                        (CASE
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) <= 0 THEN 'Empty'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * ((s.High_Level - 1) / 100)) THEN 'High Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * ((s.Medium_Level - 1) / 100)) THEN 'Medium Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) >= (s.manhole_distance * ((s.Low_Level - 1) / 100)) THEN 'Low Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d.Level) < (s.manhole_distance * ((s.Low_Level - 1) / 100)) THEN 'Near Empty'
                            ELSE 'Empty'
                        END) != 
                        (CASE
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) <= 0 THEN 'Empty'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * ((s.High_Level - 1) / 100)) THEN 'High Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * ((s.Medium_Level - 1) / 100)) THEN 'Medium Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) >= (s.manhole_distance * ((s.Low_Level - 1) / 100)) THEN 'Low Level'
                            WHEN (s.manhole_distance - s.offset_ultra_level - d_prev.Level) < (s.manhole_distance * ((s.Low_Level - 1) / 100)) THEN 'Near Empty'
                            ELSE 'Empty'
                        END)
                    )
                )
                AND  TIMESTAMPDIFF(MINUTE, d.timestamp, NOW()) < 60
                THEN 1
                ELSE 0
            END
    END AS Level_change_alert
FROM 
    mpete_manhole.data d
JOIN 
    mpete_manhole.setup s ON d.device = s.device
LEFT JOIN
    mpete_manhole.data d_prev ON d.device = d_prev.device
    AND d_prev.timestamp = (
        SELECT MAX(d2.timestamp)
        FROM mpete_manhole.data d2
        WHERE d2.device = d.device AND d2.timestamp < d.timestamp
    )
WHERE 
    d.timestamp = (
        SELECT MAX(d2.timestamp)
        FROM mpete_manhole.data d2
        WHERE d2.device = d.device
    );
