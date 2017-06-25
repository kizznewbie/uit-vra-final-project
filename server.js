var express = require('express'),
    bodyParser = require('body-parser'),
    multer = require('multer'),
    config = require('./config.js').config,
    exec = require('child_process').exec,
    fs = require('fs'),
    storage,
    upload,
    app = express();

/*init*/
storage = multer.diskStorage({
  destination: function(req, file, cb) {
    cb(null, __dirname + config.uploadPath);
  },
  filename: function(req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now() + '.jpg');
  }
});

upload = multer({storage: storage});

/*config here*/

app.use('/imgs', express.static(__dirname + '/public/imgs'));
app.use('/js', express.static(__dirname + '/public/js'));
app.use('/css', express.static(__dirname + '/public/css'));
app.use('/assets', express.static(__dirname + '/public/assets'));
app.use('/upload', express.static(__dirname + '/upload'));
app.use('/datasets', express.static(__dirname + '/datasets'));
app.use('/', express.static(__dirname + '/public/'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


/**************Function***************/
var buildMatlabQuery = function(filename, startX, startY, w, h) {
  func = config.func + '(\'' + __dirname + config.uploadPath + filename +'\',' + startX + ',' + startY + ',' + w + ',' + h + ')';
  query = config.matlabBin
          + config.option
              .replace('{matlab_func}', func)
              .replace('{logfile}', config.logfile + filename + '.txt')
              .replace('{startupFolder}', config.matlabProject);
  return query;
};

var readResult = function(filename, _res) {
  var regEx =/\-\-\-Result from here\-\-\-([\w\W]*)\-\-\-end result here\-\-\-/,
      re, name, accuracy, presision, idx;
  fs.readFile(filename, 'utf8', function(err, data) {
    if(err) {
      console.log(err);
      _res.send(500);
    }
    else {
      re = data.match(regEx)[1];
      re = re.split('\n');
      _res.send({
        resultArr: re
      });
    }
    _res.end();
  });

};

/*******Routing Here********/
app.get('/', function(req, res) {
  res.sendFile('/public/html/index.html', {root: __dirname}, function(err) {
    res.end();
  });
});

app.post('/query', upload.single('image'), function(req, res) {
  var fileName = req.file.filename,
      css = JSON.parse(req.body.css);

  var w = css.w,
      h = css.h;
      top =  css.top,
      left = css.left;
  if(!top) {
    top = 0;
  }
  if(!left) {
    left = 0;
  }
  if(!w) {
    w = 1;
  }
  if(!h) {
    h = 1;
  }

  query = buildMatlabQuery(fileName, left, top, w, h);
  exec(query, function(err, stdout, stderr) {
    readResult(config.logfile + fileName + '.txt', res);
  });

});

/*start server here*/
app.listen(3000, function() {
  console.log('server start at port 3000');
});
