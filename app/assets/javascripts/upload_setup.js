/*global uploadSetup */

var uploadSetup = function (previewTemplate) {
  new Shubox('#document-drop', {
    previewsContainer: '.form-card__documents',
    previewTemplate: previewTemplate,
    acceptedFiles: '.pdf,.jpg,.png,.gif,.doc,.docx',
    maxFilesize: 3, // MB
    error: function (_file, msg) {
      window.alert(msg)
    },
    success: function (f) {
      var source = $('#form-card__documents__handlebars_template').html()
      var template = window.Handlebars.compile(source)
      var context = {
        url: f.s3url,
        filename: f.s3url.split('/').reverse()[0]
      }
      var html = template(context)
      $('#form-card__documents').append(html)
    }
  })

  $(document).on('click', '.link--delete', function (e) {
    $(e.target).closest('.doc-preview').remove()
  })
}
