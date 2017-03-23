class FormsController < ApplicationController

  def allowed
    {
      show: :member
    }
  end

  def show
    file = Form.new(current_user.app).fill
    send_file file, type: "application/pdf", disposition: "inline"
  end
end
