SELECT
  device,
  manhole_distance,
  offset_ultra_level,
  Low_Level,
  Medium_Level,
  High_Level,
  alert_decis,
  latitude,
  longitude,
  location,
  commu,
  commu_id,
  timestamp
FROM
  mpete_manhole.setup
WHERE
  device IN ('$Setup_Device')
ORDER BY
  device DESC
LIMIT
  1;
