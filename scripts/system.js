function getPlatform() {
  var userAgent = navigator.userAgent || navigator.vendor || window.opera;
  
  if (/windows phone/i.test(userAgent)) {
    return "Windows Phone";
  }
  if (/android/i.test(userAgent)) {
    return "Android";
  }
  if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
    return "iOS";
  }
  if (/Macintosh/.test(navigator.platform)) {
    return "Mac";
  }
  if (/Win/.test(navigator.platform)) {
    return "Windows";
  }
  if (/Linux/.test(navigator.platform) || /X11/.test(userAgent)) {
    return "Linux";
  }
  if (/CrOS/.test(userAgent)) {
    return "Chrome OS";
  }
  return "Unknown Platform";
}

function getBrowser() {
  var userAgent = navigator.userAgent || navigator.vendor || window.opera;

  if (/OPR|Opera/.test(userAgent)) {
    return "Opera";
  }
  if (/Edg/.test(userAgent)) {
    return "Microsoft Edge";
  }
  if (/Chrome/.test(userAgent) && !/Chromium/.test(userAgent)) {
    return "Chrome";
  }
  if (/Safari/.test(userAgent) && !/Chromium/.test(userAgent)) {
    return "Safari";
  }
  if (/Firefox/.test(userAgent)) {
    return "Firefox";
  }
  if (/MSIE|Trident/.test(userAgent)) {
    return "Internet Explorer";
  }
  return "Unknown Browser";
}