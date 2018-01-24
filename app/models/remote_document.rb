class RemoteDocument
  attr_reader :tempfile

  def initialize(url)
    @url = url
    @tempfile = Tempfile.new.binmode
  end

  def download
    open(url) { |url_file| tempfile.write(url_file.read) }
    self
  rescue OpenURI::HTTPError
    return self if s3_download
  ensure
    rotate if landscape_image?
  end

  def pdf?
    file_type.include?("pdf")
  end

  private

  attr_reader :url

  def rotate
    @tempfile = magick_file.combine_options do |actions|
      actions.rotate "-90"
    end.tempfile
  end

  def landscape_image?
    file_type.include?("image") && magick_file.width > magick_file.height
  end

  def magick_file
    MiniMagick::Image.open(tempfile.path)
  end

  def file_type
    @_file_type ||= FileMagic.open(:mime) do |fm|
      tempfile.rewind
      fm.file(tempfile.path, true)
    end
  end

  def s3_download
    s3.get_object(
      {
        bucket: Rails.application.secrets.aws_bucket,
        key: s3_object_key,
      },
      target: tempfile.path,
    )
    true
  rescue Aws::S3::Errors::NoSuchKey
    false
  end

  def s3
    @_s3 ||= Aws::S3::Client.new(
      access_key_id: Rails.application.secrets.aws_key,
      secret_access_key: Rails.application.secrets.aws_secret,
      region: Rails.application.secrets.aws_region,
    )
  end

  def s3_object_key
    url.split("amazonaws.com/").last
  end
end
