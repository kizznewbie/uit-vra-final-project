var config = {
  matlabBin: "E:\\Software\\Matlab2017a\\bin\\matlab.exe",
  matlabProject: "C:\\Users\\hoa dai ca\\Desktop\\HocTap\\Thong_Tin_Thi_Giac\\matlab",
  logfile: "C:\\Users\\hoa dai ca\\Desktop\\HocTap\\Thong_Tin_Thi_Giac\\matlab\\logfile\\",
  option: " -wait -nodesktop -minimize -sd \"{startupFolder}\" -r \"{matlab_func};exit;\" -nosplash  -logfile \"{logfile}\"",
  func: "queryImg",
  uploadPath: "\\upload\\",
};

exports.config = config;
