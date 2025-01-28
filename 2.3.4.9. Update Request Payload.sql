INSERT INTO setup (
    device,
    location,
    latitude, 
    longitude, 
    commu,
    commu_id,
    manhole_distance,
    cover_setup,
    offset_ultra_level,
    Low_Level,
    Medium_Level,
    High_Level,
    cover_ack,
    maintenance,
    timestamp
) 
VALUES (
    '${payload.device}',
    '${payload.location}',
    '${payload.latitude}', 
    '${payload.longitude}', 
    '${payload.commu}',
    '${payload.commu_id}', 
    '${payload.manhole_distance}',
    '${payload.cover_setup}',
    '${payload.offset_ultra_level}',
    '${payload.Low_Level}',
    '${payload.Medium_Level}',
    '${payload.High_Level}',
    '${payload.cover_ack}',
    '${payload.maintenance}',
    CURRENT_TIMESTAMP()
) 
ON DUPLICATE KEY UPDATE 
    location = VALUES(location),
    latitude = VALUES(latitude),
    longitude = VALUES(longitude),
    commu = VALUES(commu),
    commu_id = VALUES(commu_id),
    manhole_distance = VALUES(manhole_distance),
    cover_setup = VALUES(cover_setup),
    offset_ultra_level = VALUES(offset_ultra_level),
    Low_Level = VALUES(Low_Level),
    Medium_Level = VALUES(Medium_Level),
    High_Level = VALUES(High_Level),
    cover_ack = CASE
        WHEN VALUES(cover_ack) IS NULL OR VALUES(cover_ack) NOT LIKE '%1%' THEN 0  -- ถ้าไม่มีเลข 1 ในข้อความ หรือเป็น NULL ให้ตั้งเป็น 0
        ELSE 1  -- ถ้ามีเลข 1 ในข้อความ ให้ตั้งเป็น 1
    END,
    maintenance = CASE
        WHEN VALUES(maintenance) IS NULL OR VALUES(maintenance) NOT LIKE '%1%' THEN 0  -- ถ้าไม่มีเลข 1 ในข้อความ หรือเป็น NULL ให้ตั้งเป็น 0
        ELSE 1  -- ถ้ามีเลข 1 ในข้อความ ให้ตั้งเป็น 1
    END,
    timestamp = CURRENT_TIMESTAMP();
