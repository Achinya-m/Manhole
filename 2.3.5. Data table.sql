SELECT
ROW_NUMBER() OVER (ORDER BY device ASC) AS `No.`,
device AS Device,
location AS Location,
latitude AS Latitude,
longitude AS Longtitude,
commu AS Communication,
commu_id AS 'Communication ID',
manhole_distance AS 'Manhole Distance',
offset_ultra_level AS 'Water Level Ultrasonic-Offset',
Low_level,
Medium_level,
High_level,
alert_decis AS 'Water Level Alert Decision',
timestamp
FROM mpete_manhole.setup
ORDER BY device ASC
LIMIT 1000000;
