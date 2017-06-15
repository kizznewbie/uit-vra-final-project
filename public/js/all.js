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
      isMouseDown = false,
      startX, startY, mouseMoveTimeout, imgW, imgH;
  var context, mouseMoveTimeout;

  var init = function() {

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
    var h = e.offsetY - startY,
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
    var url = '/query';
    $.ajax({
      url: url,
      type: 'POST',
      dataType: 'text'
    })
    .done(function(data, status, jqXHR) {
      console.log(data);
    })
    .fail(function() {
      alert('fail to send request to Server! Please try again!');
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
      console.log(e);
      var reader = new FileReader();
      reader.onload = function() {
        choosenImg.attr('src', reader.result);
      };
      reader.readAsDataURL(e.originalEvent.srcElement.files[0]);
    });
});
