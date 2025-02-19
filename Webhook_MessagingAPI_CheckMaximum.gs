function doPost(e) {
  // รับข้อมูลจาก POST request
  var jsonData = e.postData.contents;
  var data = JSON.parse(jsonData);
  
  // ตรวจสอบข้อมูลที่ได้รับจาก Grafana
  Logger.log(data);
  
  // ดึงข้อมูลจาก JSON ที่ได้รับ
  var alertTitle = data.title; // Template alert อยู่ใน

  // เช็คโควต้าการส่งข้อความ
  checkMessageQuota(alertTitle);
  
  // ส่งคำตอบกลับ
  return ContentService.createTextOutput(
    JSON.stringify({"status": "success"})
  ).setMimeType(ContentService.MimeType.JSON);
}

function sendMessageToLine(message) {
  var url = "https://api.line.me/v2/bot/message/push";
  var channelAccessToken = "GVO+IboLn7v0XjBOAmrknGjf+6mSDR5d1oyoCkY+Li1b0AxYnv4hVg81boyQJF9W8Eoa+ztniy+sXAj+yGQl7rkurfeazPczP3IjOf++tsJ2V2LsAIYTPSV806LY9ZNil55OFgLo7FrzQVaCvSkrlgdB04t89/1O/w1cDnyilFU=";

  var headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + channelAccessToken
  };

  var payload = {
    "to": "Cef71f19dbc128ee6e41d4c9c830b83c6",
    "messages": [
      {
        "type": "text",
        "text": message
      }
    ]
  };

  var options = {
    "method": "post",
    "headers": headers,
    "payload": JSON.stringify(payload)
  };

  UrlFetchApp.fetch(url, options);
}

// เช็คโควต้าการใช้ข้อความ
function checkMessageQuota(alertTitle) {
  var url = "https://api.line.me/v2/bot/message/quota/consumption";
  var channelAccessToken = "GVO+IboLn7v0XjBOAmrknGjf+6mSDR5d1oyoCkY+Li1b0AxYnv4hVg81boyQJF9W8Eoa+ztniy+sXAj+yGQl7rkurfeazPczP3IjOf++tsJ2V2LsAIYTPSV806LY9ZNil55OFgLo7FrzQVaCvSkrlgdB04t89/1O/w1cDnyilFU=";

  var headers = {
    "Authorization": "Bearer " + channelAccessToken
  };

  var options = {
    "method": "get",
    "headers": headers
  };

  var response = UrlFetchApp.fetch(url, options);
  var data = JSON.parse(response.getContentText());
  
  var remainingMessages = data.remaining; // จำนวนข้อความที่เหลือ
  var maxMessages = 75; // ขีดจำกัดข้อความที่สามารถส่งได้

  if (remainingMessages <= 0) {
    sendMessageToLine("Warning: Maximum message limit reached.");
  } else {
    // ส่งข้อความเตือนถ้าใกล้ถึงขีดจำกัด
    sendMessageToLine(alertTitle);
  }
}
