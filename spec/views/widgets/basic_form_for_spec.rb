require 'rails_helper'

describe "widgets/basic_form_for.html.rb" do
  specify do
    user = User.new

    definition = -> (f) do
      f.field :email, title: "Email Address", type: :email, required: true
      f.field :name, title: "Full Name"
      f.field :name

      f.field :password, type: :password
    end

    assign(:form_for_params, [user, { url: "/user/new" }])
    assign(:title, "User Details")
    assign(:definition, definition)

    render

    expect(rendered).to match_html <<-HTML
      <div class="expanded row">
        <div class="columns small-12 medium-6">
          <h2>User Details</h2>

          <form class="new_user" id="new_user" action="/user/new" accept-charset="UTF-8" method="post">
            <input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" />

            <label for="user_email">Email Address<span class="required"> required</span><input autofocus="autofocus" type="email" name="user[email]" id="user_email" /></label>
            <label for="user_name">Full Name<input type="text" name="user[name]" id="user_name" /></label>
            <label for="user_name">Name<input type="text" name="user[name]" id="user_name" /></label>
            <label for="user_password">Password<input type="password" name="user[password]" id="user_password" /></label>

            <input type="submit" name="commit" value="Continue" class="button special" data-disable-with="Continue" />
          </form>
        </div>
      </div>
    HTML
  end
end
