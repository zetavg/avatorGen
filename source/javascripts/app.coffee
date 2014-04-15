console.log "Hello, this is avatorGen."
root = exports ? this

root.avatorGen = {}
avatorGen.canvas = $ '#canvas'
avatorGen.img = $ '#avatorGen-img'
avatorGen.imgAnchor = $ '#avatorGen-imgAnchor'
avatorGen.downloadBtn = $ '#download'

avatorGen.readImg = (e) ->
  imgID = e.target.getAttribute("data-id");
  img = e.target.files[0]
  return if !img.type.match('image.*')
  reader = new FileReader()
  reader.onload = ((theFile) ->
    (e) ->
      $("#avatorGen-img-"+imgID).val(e.target.result)
  )(img)
  reader.readAsDataURL img
  setTimeout avatorGen.update, 500
  setTimeout avatorGen.update, 1000
  setTimeout avatorGen.update, 1500

avatorGen.refreshImage = ->
  html2canvas canvas,
    onrendered: (canvas) ->
      data = canvas.toDataURL("image/png")
      avatorGen.img.attr "src", data
      avatorGen.imgAnchor.attr "href", data
      avatorGen.downloadBtn.attr "href", data

avatorGen.scaleImg = ->
  $("#canvas .maintain-aspect-ratio img").each (intIndex) ->
    width = $(this).width()
    height = $(this).height()
    wrapperWidth = $(this).parent().width()
    wrapperHeight = $(this).parent().height()
    scaletoWidth = wrapperWidth
    scaletoHeight = height*wrapperWidth/width
    $(this).css('top', (wrapperHeight-scaletoHeight)/2)
    $(this).css('left', 0)
    if scaletoHeight < wrapperHeight
      scaletoHeight = wrapperHeight
      scaletoWidth = width*wrapperHeight/height
      $(this).css('top', 0)
      $(this).css('left', (wrapperWidth-scaletoWidth)/2)
    $(this).width(scaletoWidth)
    $(this).height(scaletoHeight)

avatorGen.update = ->
  avatorGen.templateID = $(".form .tabs-content .active").attr("id");
  html = []
  $("#" + avatorGen.templateID + " input").each (intIndex) ->
    switch $(this).attr("name")
      when "background-color" then avatorGen.canvas.css 'background-color', $(this).attr("value")
      when "image" then html.push '<img src="images/' + $(this).attr("value") + '" style="z-index: 10;">' if $(this).attr("value")?
      else
        switch $(this).attr("data-type")
          when "image"
            value = $(this).val() if $(this).val() != ''
            before = $(this).attr("data-before") ? ''
            after = $(this).attr("data-after") ? ''
            style = $(this).attr("data-style") ? ''
            maintainAspectRatio = if ($(this).attr("data-maintain-aspect-ratio") == 'true') then 'maintain-aspect-ratio' else ''
            html.push before + '<div class="img ' + maintainAspectRatio + '" style="z-index: 1; ' + style + '"><img src="' + value + '"></div>' + after
          when "text"
            if $(this).val() != undefined
              value = $(this).attr("placeholder") ? ''
              value = $(this).val() if $(this).val() != ''
              before = $(this).attr("data-before") ? ''
              after = $(this).attr("data-after") ? ''
              style = $(this).attr("data-style") ? ''
              html.push '<div style="' + style + '">' + before + value + after + '</div>'
  avatorGen.canvas.html(html.join(''))
  avatorGen.scaleImg()
  avatorGen.refreshImage()

avatorGen.update()

# $("input").each (intIndex) ->
$("input").bind "keyup input paste", ->
  avatorGen.update()

$("a").bind "keyup click", ->
  setTimeout avatorGen.update, 500
  setTimeout avatorGen.update, 1000
  setTimeout avatorGen.update, 1500

$(".input-img").on "change", avatorGen.readImg

avatorGen.showCanvas = ->
  avatorGen.canvas.css 'position', 'fixed'
  avatorGen.canvas.css 'top', '0'
  avatorGen.canvas.css 'left', '0'
  avatorGen.canvas.css 'z-index', '1000'
