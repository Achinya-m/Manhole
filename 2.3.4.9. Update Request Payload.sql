INSERT INTO setup (
    device,
    location,
    latitude, 
    longitude, 
    commu,
    commu_id,
    manhole_distance,
    offset_ultra_level,
    Low_Level,
    Medium_Level,
    High_Level,
    alert_decis, 
    timestamp
) 
VALUES (
    '${payload.device}',
    '${payload.location}',
    '${payload.latitude}', 
    '${payload.longtitude}', 
    '${payload.commu}',
    '${payload.commu_id}', 
    '${payload.manhole_distance}',
    '${payload.offset_ultra_level}',
    '${payload.Low_Level}',
    '${payload.Medium_Level}',
    '${payload.High_Level}',
    '${payload.alert_decis}', 
    CURRENT_TIMESTAMP()
) 
ON DUPLICATE KEY UPDATE 
    location = VALUES(location),
    latitude = VALUES(latitude),
    longitude = VALUES(longitude),
    commu = VALUES(commu),
    commu_id = VALUES(commu_id),
    manhole_distance = VALUES(manhole_distance),
    offset_ultra_level = VALUES(offset_ultra_level),
    Low_Level = VALUES(Low_Level),
    Medium_Level = VALUES(Medium_Level),
    High_Level = VALUES(High_Level),
    alert_decis = VALUES(alert_decis),
    timestamp = CURRENT_TIMESTAMP();
