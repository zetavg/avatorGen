(function() {
  var root;

  console.log("Hello, this is avatorGen.");

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.avatorGen = {};

  avatorGen.canvas = $('#canvas');

  avatorGen.img = $('#avatorGen-img');

  avatorGen.imgAnchor = $('#avatorGen-imgAnchor');

  avatorGen.downloadBtn = $('#download');

  avatorGen.readImg = function(e) {
    var img, imgID, reader;
    imgID = e.target.getAttribute("data-id");
    img = e.target.files[0];
    if (!img.type.match('image.*')) {
      return;
    }
    reader = new FileReader();
    reader.onload = (function(theFile) {
      return function(e) {
        return $("#avatorGen-img-" + imgID).val(e.target.result);
      };
    })(img);
    reader.readAsDataURL(img);
    setTimeout(avatorGen.update, 500);
    setTimeout(avatorGen.update, 1000);
    return setTimeout(avatorGen.update, 1500);
  };

  avatorGen.refreshImage = function() {
    return html2canvas(canvas, {
      onrendered: function(canvas) {
        var data;
        data = canvas.toDataURL("image/png");
        avatorGen.img.attr("src", data);
        avatorGen.imgAnchor.attr("href", data);
        return avatorGen.downloadBtn.attr("href", data);
      }
    });
  };

  avatorGen.update = function() {
    var html;
    avatorGen.refreshImage();
    avatorGen.templateID = $(".form .tabs-content .active").attr("id");
    html = [];
    $("#" + avatorGen.templateID + " input").each(function(intIndex) {
      var after, before, value, _ref, _ref1, _ref2, _ref3, _ref4;
      switch ($(this).attr("name")) {
        case "background-color":
          return avatorGen.canvas.css('background-color', $(this).attr("value"));
        case "image":
          if ($(this).attr("value") != null) {
            return html.push('<img src="images/' + $(this).attr("value") + '">');
          }
          break;
        default:
          switch ($(this).attr("data-type")) {
            case "image":
              if ($(this).val() !== '') {
                value = $(this).val();
              }
              before = (_ref = $(this).attr("data-before")) != null ? _ref : '';
              after = (_ref1 = $(this).attr("data-after")) != null ? _ref1 : '';
              return html.push(before + '<img style="z-index: 0; ' + $(this).attr("data-style") + '" src="' + value + '">' + after);
            case "text":
              if ($(this).val() !== void 0) {
                value = (_ref2 = $(this).attr("placeholder")) != null ? _ref2 : '';
                if ($(this).val() !== '') {
                  value = $(this).val();
                }
                before = (_ref3 = $(this).attr("data-before")) != null ? _ref3 : '';
                after = (_ref4 = $(this).attr("data-after")) != null ? _ref4 : '';
                return html.push('<div style="' + $(this).attr("data-style") + '">' + before + value + after + '</div>');
              }
          }
      }
    });
    return avatorGen.canvas.html(html.join(''));
  };

  avatorGen.update();

  $("input").bind("keyup input paste", function() {
    return avatorGen.update();
  });

  $("a").bind("keyup click", function() {
    setTimeout(avatorGen.update, 500);
    setTimeout(avatorGen.update, 1000);
    return setTimeout(avatorGen.update, 1500);
  });

  $(".input-img").on("change", avatorGen.readImg);

  avatorGen.showCanvas = function() {
    avatorGen.canvas.css('position', 'fixed');
    avatorGen.canvas.css('top', '0');
    avatorGen.canvas.css('left', '0');
    return avatorGen.canvas.css('z-index', '1000');
  };

}).call(this);
