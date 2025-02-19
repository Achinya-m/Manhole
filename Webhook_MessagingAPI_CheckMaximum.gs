function doPost(e) {
  // รับข้อมูลจาก POST request
  var jsonData = e.postData.contents;
  var data = JSON.parse(jsonData);
  
  // ตรวจสอบข้อมูลที่ได้รับจาก Grafana
  Logger.log(data);
  
  // ดึงข้อมูลจาก JSON ที่ได้รับ
  var alertTitle = data.title; // Template alert อยู่ใน

  // เช็คจำนวนข้อความที่ใช้ไปแล้ว
  checkMessageLimit();

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

// เช็คจำนวนข้อความที่ส่งไปแล้ว
function checkMessageLimit() {
  var url = "https://api.line.me/v2/bot/message/quota/consumption";
  var headers = {
    "Authorization": "Bearer " + "GVO+IboLn7v0XjBOAmrknGjf+6mSDR5d1oyoCkY+Li1b0AxYnv4hVg81boyQJF9W8Eoa+ztniy+sXAj+yGQl7rkurfeazPczP3IjOf++tsJ2V2LsAIYTPSV806LY9ZNil55OFgLo7FrzQVaCvSkrlgdB04t89/1O/w1cDnyilFU="
  };

  var response = UrlFetchApp.fetch(url, { "headers": headers });
  var data = JSON.parse(response.getContentText());
  var totalUsage = data.totalUsage; // จำนวนข้อความที่ใช้ไปแล้ว

  var groupUrl = "https://api.line.me/v2/bot/group/Cef71f19dbc128ee6e41d4c9c830b83c6/members/count";
  var groupResponse = UrlFetchApp.fetch(groupUrl, { "headers": headers });
  var groupData = JSON.parse(groupResponse.getContentText());
  var member = groupData.count; // จำนวนสมาชิกไม่รวม LIne OA

  if (member > 0) { // ป้องกันหารด้วยศูนย์
    var maxMessages = 300 / member; // ขีดจำกัดสูงสุด (300 ข้อความ/สมาชิก/เดือน)
    var totalMessages = totalUsage / member; // ตรวจสอบว่าตอนนี้ใช้ไปกี่ข้อความเมื่อนับสมาชิก

    // เช็คว่าจำนวนข้อความใกล้ถึงขีดจำกัด
    if (totalMessages === maxMessages - 1) {
      sendMessageToLine("Warning: Maximum message limit is almost reached."); 
    }
  }
}
// โค้ดนี่จะใช้ได้สมบูรณ์ถ้า 300/จำนวนสมาชิก ได้เลขจำนวนเต็มไม่มีทศนิยม และ Add Bot เข้ากลุ่มหลังสมาชิกคนอื่นๆ(เพื่อป้องกัน Bot Alert ก่อนสมาชิกครบ) และต้องปิด Auto Respond อื่นๆนกเหนือจาก API
