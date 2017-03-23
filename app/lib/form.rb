class Form
  def initialize(app)
    @pdf_writer = PdfForms.new('pdftk')
    @pdf_file = Rails.root.join("lib/assets/form.pdf")
    @app = app
  end

  def field_names
    @pdf_writer.get_field_names @pdf_file
  end

  def fill
    file = Tempfile.new(["form", ".pdf"])
    @pdf_writer.fill_form(@pdf_file, file, data)
    file.path
  end

  private

  def data
    {
      "applicantName" => @app.user.full_name,
      "dateBirth" => "",
      "phoneNumber" => @app.phone_number,
      "applicantComments" => @app.mailing_address,
      "socialSecurityNumber" => ""
    }
  end
end
