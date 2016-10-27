# For "Let's Encrypt" SSL certs. See README-SSL.md and http://collectiveidea.com/blog/archives/2016/01/12/lets-encrypt-with-a-rails-app-on-heroku/

class AcmeChallengesController < ApplicationController
  def allowed
    {
      show: :guest
    }
  end

  def show
    expected_request = ENV["ACME_CHALLENGE_REQUEST"]
    response = ENV["ACME_CHALLENGE_RESPONSE"]

    raise "Challenge response not set" unless response.present?
    raise "Challenge request not set" unless expected_request.present?
    raise "Challenge request does not match expected request" unless expected_request == params[:id]

    render plain: response
  end
end
