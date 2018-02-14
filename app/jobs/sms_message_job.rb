class SmsMessageJob < ApplicationJob
  def perform(message:)
    twilio_client = Twilio::REST::Client.new
    twilio_client.messages.create(
      to: message.phone,
      from: Rails.application.secrets.twilio_phone_number,
      body: message.body,
      media_url: Rails.env.development? || Rails.env.test? ? message.screenshots : presigned_urls(message.screenshots),
    )
  end

  def presigned_urls(urls)
    s3 = Aws::S3::Client.new(
      access_key_id: Rails.application.secrets.aws_key,
      secret_access_key: Rails.application.secrets.aws_secret,
      region: Rails.application.secrets.aws_region,
    )
    bucket = Rails.application.secrets.aws_bucket
    urls.map do |source_url|
      url = URI.parse(source_url)
      key = url.path[1..-1]
      obj = Aws::S3::Object.new(bucket, key, client: s3)
      obj.presigned_url(:get, expires_in: 600)
    end
  end
end
