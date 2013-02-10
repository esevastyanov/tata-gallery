$ ($) ->
  window.upImage = (collectionName, imageURL, successCB) ->
    $.post '/up', {collectionName:collectionName, imageURL:imageURL}, successCB

  window.downImage = (collectionName, imageURL, successCB) ->
    $.post('/down', {collectionName:collectionName, imageURL:imageURL}, successCB)

  window.changeDescription = (collectionName, description, successCB) ->
    $.post '/collectionDescription', {collectionName:collectionName, description:description}, successCB

  window.changeType = (collectionName, type, successCB) ->
    $.post '/collectionType', {collectionName:collectionName, type:type}, successCB

  window.getCollectionType = () ->
    window.location.href.split('=')[1]

  window.uploadForm = ($fileForm) ->
    formData = new FormData $fileForm[0]
    $.ajax
      url:  '/upload'
      type: 'POST'
      xhr:  () -> #custom xhr
        myXhr = $.ajaxSettings.xhr()
#        if myXhr.upload #check if upload property exists
#          myXhr.upload.addEventListener 'progress', progressHandlingFunction, false #for handling the progress of the upload
        myXhr
#      beforeSend: beforeSendHandler
#      success: completeHandler
#      error: errorHandler
      data: formData
#      Options to tell JQuery not to process data or worry about content-type
      cache:  false
      contentType:  false
      processData:  false

  (checkAuthenticate = () ->
    window.isAdmin = false
    $.get '/login', (data) ->
      return unless data.user
      window.isAdmin = true
      $('.admin-control').removeClass 'admin-control'
      $('#login').hide()
      $('#logout').show()
  )()

  (createUploadForm = () ->
    $addFileForm = $  '<form enctype="multipart/form-data" method="post">'+
                        '<input type="file" name="upload" multiple="multiple" class="file">'+
                        '<input type="text" name="name" class="file">'+
                        '<input type="text" name="type" class="file">'+
                      '</form>'
    $('.footer').append $addFileForm
    $('#new-collection-add').click () ->
      $fileInput = $addFileForm.find('input[type=file]').val ""
      $cNameInput = $addFileForm.find('input[name=name]').val ""
      $typeInput = $addFileForm.find('input[name=type]').val getCollectionType()
      $fileInput.change () ->
        $fileInput.unbind()
        uploadForm $addFileForm unless $fileInput.val() is ""
      $fileInput.click()
  )()

  (createLoginForm = () ->
    $loginDialogBox = $('#login-dialog').tmpl()
    $('#login').click () ->
      $loginDialogBox.dialog
        dialogClass : "login-form-dialog"
        buttons :
          "Ok" : () ->
            formData = new FormData()
            formData.append 'username', $('#username').val()
            formData.append 'password', $('#password').val()
            $.ajax
              url: '/login'
              type: 'POST'
              data: formData
              error: () -> $loginDialogBox.dialog("widget").effect "shake", times : 3, 333
              success: () -> window.location.replace '/'
              #Options to tell JQuery not to process data or worry about content-type
              cache: false
              contentType: false
              processData: false
          "Cancel" : () ->
            $loginDialogBox.dialog "close"
  )()


