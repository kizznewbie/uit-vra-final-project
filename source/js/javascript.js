$(function() {
  var drawingPanel = $('#drawing-panel'),
      drawingWrapper = $('div.drawing-area'),
      queryBtn = $('#query-btn'),
      namespace = 'canvas',
      canvas = drawingPanel[0],
      canvasWrapperPos = drawingWrapper.offset(),
      canvasWrapperX = canvasWrapperPos.left,
      canvasWrapperY = canvasWrapperPos.top,
      isMouseDown = false;
  var context, mouseMoveTimeout;

  var init = function() {
    canvas.width = drawingWrapper.width(),
    canvas.height = drawingWrapper.height()
    context = canvas.getContext('2d');
    context.lineWidth = 10;
    context.strokeStyle = 'black';
  };

  var drawingPanelMouseDownHandler = function(e) {
    isMouseDown = true;
    context.beginPath();
    context.moveTo(e.offsetX, e.offsetY);
  };

  var drawingPanelMouseUpHandler = function(e) {
    isMouseDown = false;
    context.closePath();
  };

  var drawingPanelMouseMoveHandler = function(e) {
    if(mouseMoveTimeout) {
      clearTimeout(mouseMoveTimeout);
    }
    mouseMoveTimeout = setTimeout(function() {
      if(isMouseDown) {
        context.lineTo(e.offsetX, e.offsetY);
        context.stroke();
      }
    }, 10);
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

  drawingPanel
    .off('mousedown.' + namespace)
    .on('mousedown.' + namespace, function(e) {
      drawingPanelMouseDownHandler.call(this, e);
    })
    .off('mouseup.' + namespace)
    .on('mouseup.' + namespace, function(e) {
      drawingPanelMouseUpHandler.call(this, e);
    })
    .off('mousemove.' + namespace)
    .on('mousemove.' + namespace, function(e) {
      drawingPanelMouseMoveHandler.call(this, e);
    });

  queryBtn
    .off('click.' + namespace)
    .on('click.' + namespace, function(e) {
      sendAjax();
    });
});
