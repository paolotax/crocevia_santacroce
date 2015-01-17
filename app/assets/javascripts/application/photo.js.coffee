jQuery ->
  
  # file upload non incluso
  if $("#new_photo").length
    $("#new_photo").fileupload
      dataType: "script"
      add: (e, data) ->
        types = /(\.|\/)(gif|jpe?g|png)$/i
        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", file).trim()) if $('#template-upload').length > 0
          $('#new_photo').append(data.context)
          console.log(data)
          data.submit()
        else
          alert("#{file.name} non è supportato (gif, jpg, or png)")
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
          if progress is 100
            data.context.hide()
              

    new PhotoCropper()

class PhotoCropper
  constructor: ->
    console.log("CROPPAMI")
    $('#cropbox').Jcrop
      # aspectRatio: 1
      # setSelect: [0, 0, 800, 800]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#photo_crop_x').val(coords.x)
    $('#photo_crop_y').val(coords.y)
    $('#photo_crop_w').val(coords.w)
    $('#photo_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'