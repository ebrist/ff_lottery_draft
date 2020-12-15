shinyjs.spin = function(params) {
  var defaultParams = {
    pnum1 : null,
    pnum2 : null,
    pnum3 : null
  };
  
  params = shinyjs.getParams(params, defaultParams);

  $('#slotpanel ul').playSpin({
    endNum: [params.pnum1, params.pnum2, params.pnum3],
  });
};
