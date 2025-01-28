SELECT
  ROW_NUMBER() OVER (ORDER BY s.device ASC) AS `No.`,
  s.device AS Device,
  s.location AS Location,
  s.latitude AS Latitude,
  s.longitude AS Longitude,
  s.commu AS Communication,
  s.commu_id AS 'Communication ID',
  s.manhole_distance AS 'Manhole Distance',
  s.offset_ultra_level AS 'Water Level Ultrasonic-Offset',
  d.Level2 AS "Manhole Cover Ultrasonic",
  s.cover_setup AS "Manhole Cover Setup",
  CASE
        WHEN d.Level2 > s.cover_setup THEN 'OPEN !'
        WHEN d.Level2 = 0 THEN 'OPEN !'
        ELSE 'CLOSE'
  END AS "Cover Status",

  CONCAT(
    s.High_level, 
    ' % (', 
    ROUND(s.manhole_distance * (s.High_level / 100), 2), 
    ' cm)'
  ) AS "High Level,",

  CONCAT(
    s.Medium_level, 
    ' % (', 
    ROUND(s.manhole_distance * (s.Medium_level / 100), 2), 
    ' cm)'
  ) AS "Medium Level,",

  CONCAT(
    s.Low_level, 
    ' % (', 
    ROUND(s.manhole_distance * (s.Low_level / 100), 2), 
    ' cm)'
  ) AS "Low Level,",


  s.timestamp
FROM mpete_manhole.setup s
JOIN mpete_manhole.data d ON s.device = d.device  -- เชื่อมโยงข้อมูลจากตาราง data ตาม device
WHERE d.timestamp = (
    SELECT MAX(d2.timestamp)
    FROM mpete_manhole.data d2
    WHERE d2.device = d.device
)
ORDER BY d.device ASC;
