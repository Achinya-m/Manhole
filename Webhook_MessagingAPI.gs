function doPost(e) {
  // รับข้อมูลจาก POST request
  var jsonData = e.postData.contents;
  var data = JSON.parse(jsonData);
  
  // ตรวจสอบข้อมูลที่ได้รับจาก Grafana
  Logger.log(data);
  
  // ดึงข้อมูลจาก JSON ที่ได้รับ
  var alertTitle = data.title; // Template alert อยู่ใน

  // สร้างข้อความที่ต้องการส่งไปยัง Line
  var message = alertTitle;
  
  // ส่งข้อความไปยัง Line
  sendMessageToLine(message);
  
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
    "to": "Cef71f19dbc128ee6e41d4c9c830b83c6",  //Group: MPE_Group_Manhole_Alert
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
