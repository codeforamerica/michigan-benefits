/*global $,uploadSetup,Shubox */

var uploadSetup = function (previewTemplate) {
  new Shubox('#document-drop', {
    previewsContainer: '.form-card__documents',
    clickable: '#click-to-upload',
    previewTemplate: previewTemplate,
    acceptedFiles: '.pdf,.jpg,.jpeg,.png,.gif',
    maxFilesize: 8, // MB
    error: function (file, msg) {
      var error = '<i class="icon-warning"></i> ' + msg
      $(file.previewElement).find('.text--error').html(error).show()
    },
    success: function (file) {
      var button = $('#click-to-upload')
      var buttonHtml = button.html()
      var titleH4 = $(file.previewElement).find('h4')
      var titleText = titleH4.html()

      button.html(buttonHtml.replace('Upload documents', 'Upload more documents'))
      titleH4.html(titleText.replace('Uploading', 'Uploaded'))
      $(file.previewElement).find('input[type="hidden"]').val(file.s3url)
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
