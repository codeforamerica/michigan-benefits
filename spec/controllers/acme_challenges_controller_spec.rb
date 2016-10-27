require 'rails_helper'

describe AcmeChallengesController do
  describe "routing" do
    specify do
      expect(get: "/.well-known/acme-challenge/KEY").to route_to "acme_challenges#show", id: "KEY"
    end
  end

  describe "#show" do
    let(:challenge_response) { "challenge-request.response" }
    let(:challenge_request) { "challenge-request" }
    let(:id) { "challenge-request" }

    def get_show
      with_modified_env ACME_CHALLENGE_REQUEST: challenge_request, ACME_CHALLENGE_RESPONSE: challenge_response do
        get :show, params: { id: id }
      end
    end

    context "when the challenge response is not set" do
      let(:challenge_response) { "" }
      specify { expect { get_show }.to raise_exception "Challenge response not set" }
    end

    context "when the challenge request is not set" do
      let(:challenge_request) { "" }
      specify { expect { get_show }.to raise_exception "Challenge request not set" }
    end

    context "when the challenge request does not match the expected one" do
      let(:id) { "something-else" }
      specify { expect { get_show }.to raise_exception "Challenge request does not match expected request" }
    end

    context "when everything is configured properly" do
      specify do
        get_show
        expect(response.body).to eq challenge_response
      end
    end
  end
end
