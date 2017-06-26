$(function() {
  var imgPanel = $('#img-panel'),
      imgWrapper = $('.img-area'),
      overlay = $('#overlay'),
      choosenImg = $('#choosen-img'),
      queryBtn = $('#query-btn'),
      clearBtn = $('#clear-btn'),
      browseBtn = $('#browse-btn'),
      fileBtn = $('#file-btn'),
      namespace = 'imageRetrieval',
      resultPopup = $('#popup-result'),
      resultImg = resultPopup.find('#img-content'),
      loadingPopup = $('#popup-loading'),
      popupCloseBtn = $('#popup-close-btn'),
      popupOverlay = $('#popup-result div.popup-overlay'),
      isMouseDown = false,
      startX, startY, mouseMoveTimeout, w, h, imgW, imgH;
  var context, mouseMoveTimeout;

  var init = function() {

  };

  var openPopup = function(popup) {
    popup.css('display', 'block');
    popup.animate({
      opacity: 1
    }, 500, 'swing');
  };

  var closePopup = function(popup, callback) {

    popup.animate({
      opacity: 0
    }, 500, 'swing', function() {
      popup.css('display', 'none');
      if(callback) {
        callback();
      }
    });
  };

  var renderResult = function(resultArr) {
    var template = '<div class="img-wrapper">' +
                      '<div class="col-1 col">{rank}</div>' +
                      '<div class="col-2 col"><img src="{src0}" class="img-item"></div>' +
                      '<div class="col-3 col"><img src="{src1}" class="img-item"></div>' +
                      '<div class="col-4 col"><img src="{src2}" class="img-item"></div>' +
                      '<div class="col-5 col"><img src="{src3}" class="img-item"></div>' +
                      '<div class="clear-fix"></div>' +
                   '</div>';
    resultImg.html('');
    for(var i = 0; i < resultArr.length; i++) {
      if(resultArr[i]) {
        var re = resultArr[i].split(';');
        resultImg.append(template
                          .replace('{rank}', i + 1)
                          .replace('{src0}', re[0])
                          .replace('{src1}', re[1])
                          .replace('{src2}', re[2])
                          .replace('{src3}', re[3])
                        );
      }
    }
  };

  var choosenImgMouseMove = function(e) {
    var _css = {
      top: '',
      bottom: '',
      right: '',
      left: '',
      width: '',
      height: ''
    };
    h = e.offsetY - startY;
    w = e.offsetX - startX;
    if(h < 0) {
      _css.bottom = imgH - startY;
      _css.height = Math.abs(h);
    }
    else {
      _css.top = startY;
      _css.height = h;
    }
    if(w < 0) {
      _css.right = imgW - startX;
      _css.width = Math.abs(w);
    }
    else {
      _css.left = startY;
      _css.width = w;
    }
    overlay.css(_css);
  };

  var sendAjax = function() {
    var url = '/query',
        formData = new FormData();
    var _css = {
      w: w/imgW,
      h: h/imgH,
      top: parseInt(overlay.css('top'))/imgW,
      left: parseInt(overlay.css('left'))/imgW,
    };
    openPopup(loadingPopup);
    formData.append('image', fileBtn[0].files[0]);
    formData.append('css', JSON.stringify(_css));
    $.ajax({
      url: url,
      type: 'POST',
      timeout: 1000*60*60*24,
      processData: false,
      contentType: false,
      enctype: 'multipart/form-data',
      dataType: 'json',
      data: formData
    })
    .done(function(data, status, jqXHR) {
      console.log(data);
      closePopup(loadingPopup, function() {
        renderResult(data.resultArr);
        openPopup(resultPopup);
      });
    })
    .fail(function() {
      closePopup(loadingPopup, function() {
        alert('fail to send request to Server! Please try again!');
      });
    });
  };

  init();

  queryBtn
    .off('click.' + namespace)
    .on('click.' + namespace, function(e) {
      sendAjax();
    });
  clearBtn
    .off('click.' + namespace)
    .on('click.' + namespace, function(e) {
      choosenImg.attr('src', '');
      queryBtn.attr('disabled', true);
    });
  choosenImg
    .off('mousedown.' + namespace)
    .on('mousedown.' + namespace, function(e) {
      isMouseDown = true;
      startY = e.offsetY;
      startX = e.offsetX;
      overlay.css({
        top: e.offsetY,
        left: e.offsetX,
        'display': 'block'
      });
    })
    .off('mouseup.' + namespace)
    .on('mouseup.' + namespace, function(e) {
      isMouseDown = false;
      if(overlay.innerWidth() == 0 || overlay.innerHeight() == 0) {
        overlay.css('display', 'none');
      }
    })
    .off('mousemove.' + namespace)
    .on('mousemove.' + namespace, function(e) {
      if(isMouseDown) {
        clearTimeout(mouseMoveTimeout);
        mouseMoveTimeout = setTimeout(function() {
          choosenImgMouseMove(e);
        }, 10);
      }
    })
  browseBtn
    .off('click.' + namespace)
    .on('click.' + namespace, function(e) {
      fileBtn.trigger('click');
    });
  choosenImg[0].onload = function() {
    imgH = choosenImg.height();
    imgW = choosenImg.width();
    queryBtn.attr('disabled', false);
  };
  fileBtn
    .off('change.' + namespace)
    .on('change.' + namespace, function(e) {
      var reader = new FileReader();
      reader.onload = function() {
        choosenImg.attr('src', reader.result);
      };
      reader.readAsDataURL(e.originalEvent.srcElement.files[0]);
    });
  popupCloseBtn
    .add(popupOverlay)
    .off('click.' + namespace)
    .on('click.' + namespace, function(e) {
      closePopup(resultPopup);
    });
});
