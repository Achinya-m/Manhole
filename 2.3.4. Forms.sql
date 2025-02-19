SELECT
  device,
  manhole_distance,
  cover_setup,
  offset_ultra_level,
  Low_Level,
  Medium_Level,
  High_Level,
  latitude,
  longitude,
  location,
  commu,
  commu_id,
  "Only MWA admin can settings" AS Text,
  CASE 
        WHEN cover_ack = 1 THEN '🔕 Disable Line Notify [Cover Status]'
        ELSE '🔔 Enable Line Notify'
  END AS "cover ack",
  CASE 
        WHEN maintenance = 1 THEN '🔕 Disable Line Notify [Cover Status and Level Status]'
        ELSE '🔔 Enable Line Notify'
  END AS maintenance,
  timestamp
FROM
  mpete_manhole.setup
WHERE
  device IN ('$Setup_Device')
ORDER BY
  device DESC
LIMIT
  1;
