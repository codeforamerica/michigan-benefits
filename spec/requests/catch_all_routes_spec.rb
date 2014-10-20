require 'rails_helper'

describe "catch-all route", :type => :request do
  it "catches top-level URLs" do
    get "/boogie-boo"
    expect(response).to redirect_to(root_url)
  end

  it "catches second-level URLs" do
    get "/boogie-boo/wow"
    expect(response).to redirect_to(root_url)
  end
end
