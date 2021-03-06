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
    cb(null, '/upload/');
  },
  filename: function(req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now());
  }
});

upload = multer({storage: storage});

/*config here*/

app.use('/imgs', express.static(__dirname + '/public/imgs'));
app.use('/js', express.static(__dirname + '/public/js'));
app.use('/css', express.static(__dirname + '/public/css'));
app.use('/assets', express.static(__dirname + '/public/assets'));
app.use('/', express.static(__dirname + '/public/'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


/**************Function***************/
var buildMatlabQuery = function(filename) {
  func = config.func + '(\'' + filename +'\')';
  query = config.matlabBin
          + config.option
              .replace('{matlab_func}', func)
              .replace('{logfile}', config.logfile + filename + '.txt')
              .replace('{startupFolder}', config.matlabProject);
  return query;
};

var readResult = function(filename, callback) {
  var fileName = config.logfile + filename + '.txt',
      regEx =/\-\-\-Result from here\-\-\-([\w\W]*)\-\-\-end result here\-\-\-/,
      res = [],
      re, name, accuracy, presision, idx;
  fs.readFile(fileName, 'utf8', function(err, data) {
    if(err) {

    }
    else {
      re = data.match(regEx)[1];
      console.log(re);
      re = re.split('\n');
      for(i = 0; i < re.length; i++) {
        res[i] = {};
        idx = re[i].search(':');
        res[i].name = re[i].substring(0, idx - 1);
        re[i] = re[i].substring(idx + 1, re[i].length - 1);
        re[i] = re[i].split(' ');
        res[i].accuracy = re[i][0];
        res[i].presision = re[i][1];
      }
      console.log(res);
    }
  });

};

readResult('wao');
/*******Routing Here********/
app.get('/', function(req, res) {
  res.sendFile('/public/html/index.html', {root: __dirname}, function(err) {
    res.end();
  });
});

app.post('/query', upload.single('image'), function(req, res) {
  query = buildMatlabQuery('wao');
  exec(query, function(err, stdout, stderr) {


    res.send(query);
    res.end();
  });

});

/*start server here*/
app.listen(3000, function() {
  console.log('server start at port 3000');
});
