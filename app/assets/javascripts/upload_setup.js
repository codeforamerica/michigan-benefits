/*global $,uploadSetup,Shubox */

var uploadSetup = function (previewTemplate) {
  new Shubox('#document-drop', {
    previewsContainer: '.form-card__documents',
    clickable: '#click-to-upload',
    previewTemplate: previewTemplate,
    acceptedFiles: '.pdf,.jpg,.jpeg,.png,.gif',
    maxFilesize: 3, // MB
    error: function (file, msg) {
      window.alert(msg)
      $(file.previewElement).remove()
    },
    success: function (file) {
      var button = $('#click-to-upload')
      var buttonHtml = button.html()
      var titleH4 = $(file.previewElement).find('h4')
      var titleText = titleH4.html()

      button.html(buttonHtml.replace('Upload documents', 'Upload more documents'))
      titleH4.html(titleText.replace('Uploading', 'Uploaded'))
    },
    addedfile: function () {
      $('[data-done-uploading]').attr('disabled', true)
    },
    queuecomplete: function () {
      $('[data-done-uploading]').removeAttr('disabled')
    }
  })

  $(document).on('click', '.link--delete', function (e) {
    e.preventDefault()
    $(e.target).closest('.doc-preview').remove()
  })
}
