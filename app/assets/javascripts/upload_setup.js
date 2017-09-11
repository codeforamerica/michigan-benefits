/*global uploadSetup */

var uploadSetup = function (previewTemplate) {
  new Shubox('#document-drop', {
    previewsContainer: '.form-card__documents',
    clickable: '#click-to-upload',
    previewTemplate: previewTemplate,
    acceptedFiles: '.pdf,.jpg,.jpeg,.png,.gif',
    maxFilesize: 8, // MB
    error: function (file, msg) {
      window.alert(msg)
      $(file.previewElement).remove()
    },
    success: function (file) {
      var button = $('#click-to-upload')
      var buttonHtml = button.html()
      button.html(buttonHtml.replace('Upload documents', 'Upload more documents'))

      var source = $('#form-card__documents__handlebars_template').html()
      var template = window.Handlebars.compile(source)
      var context = {
        url: file.s3url,
        filename: file.s3url.split('/').reverse()[0]
      }

      var html = template(context)
      $(file.previewElement).remove()
      $('#form-card__documents').append(html)
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
