class FakeTwilioClient
  # HT Thoughtbot: https://robots.thoughtbot.com/testing-sms-interactions

  Message = Struct.new(:from, :to, :body)

  cattr_accessor :messages
  self.messages = []

  def initialize; end

  def messages
    self
  end

  def create(args)
    self.class.messages << Message.new(args[:from], args[:to], args[:body])
    if Rails.env == "development"
      puts "\n\nSMS message that would have been sent:\n"
      puts "TO: #{args[:to]}"
      puts "FROM: #{args[:from]}"
      puts "BODY: #{args[:body]}\n\n"
    end
  end

  def self.clear!
    messages.clear
  end
end
