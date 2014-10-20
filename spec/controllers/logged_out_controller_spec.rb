require 'rails_helper'

describe LoggedOutController do
  it "should get index" do
    get :index
    expect(response).to be_success
  end
end
