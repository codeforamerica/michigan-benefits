# README

This project is built on top of [Citizen Rails](https://github.com/citizencode/citizen-rails). 

**See [README-citizen-rails-template.md](README-citizen-rails-template.md) for instructions on
using the Citizen Rails template project as a base for your own project.**


## Developing

### Getting Started

* After cloning this repo, run: `bin/setup`
* Run `citizen doctor` repeatedly until all the failures are fixed.


### citizen-scripts

The Gemfile includes `citizen-scripts` which is a collection of useful dev utils. It includes a command
called `citizen`. Running `citizen` with no arguments will show usage information. Depending on your 
Ruby setup, you might need to run `bundle exec citizen` instead of just `citizen`.


### Day-to-day

* Run the server: `heroku local` and [http://localhost:3000](http://localhost:3000)
* Run tests: `citizen test`
* Pull, run tests, push: `citizen pushit`


### Debugging

* Call `byebug` anywhere in the code to stop execution and get a debugger console.
* Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.
* (Of course, [RubyMine](https://www.jetbrains.com/ruby/) includes a great [visual debugger](https://www.jetbrains.com/ruby/features/ruby_debugger.html)).

### CircleCI green builds deploy to Heroku staging servers

1. Get your Heroku API Key for a user from (https://dashboard.heroku.com/account)
1. Paste API Key in the CircleCI account settings page (https://circleci.com/account/heroku)
1. Set your user as the deploy user CircleCI per project settings page (https://circleci.com/gh/citizencode/skoshi/edit#heroku)
1. Ensure that your <github username>@circleci.com and generated ssh key show up on heroku (https://dashboard.heroku.com/account)
1. Click rebuild if necessary 

## What's Included

### Simple User Authorization

There are 3 user levels: **admin**, **member**, and **guest**. **Admins** are users whose `admin` flag is set.
**Members** are users who aren't admins. **Guests** are non-logged-in visitors.

By default, only admins are authorized to call a controller action. To let other user levels
in, override the `allowed` method in your controller to return a hash of actions and user levels:

```ruby
def allowed
  { 
    index: :admin, # only admins
    show: :member, # admins and members
    new: :guest, # admins, members, and non-logged-in visitors (everyone)
  }
end
```

### Basic Auth

Set an environment variable called `BASIC_AUTH` in the format `<username>:<password>` (e.g., `chewie:r0000ar`).
Basic auth will be enabled if that environment variable exists.


### Fortitude

We use [Fortitude](https://github.com/ageweke/fortitude) for views. You'll love it.

Use `bin/fortify` to convert HTML to Fortitude.



### X-ray

In your browser, press `command-shift-X` to see which controller, layout, and views rendered the page. Click on something
in the view to have it open in your editor. (Use the gear icon in the lower right corner to configure your editor.)
[Read more](https://github.com/brentd/xray-rails).



### Mom

[Mom](spec/support/mom.rb) is a simple way to create objects for tests. Instead of some convoluted DSL for building
objects, just use plain Ruby.

* Call `build` (e.g., `build :user`) to instantiate a new, unsaved object
* Call `create` (e.g., `create :user`) to instantiate and save a new object
* Define methods (e.g. `def user...end`) for each class you want to easily create objects for
* You are not limited to just creating models; since it's plain Ruby, you can do anything 
  (e.g., `create :team_with_members_and_locations, "Great team", member_names: %w[Alice Billy Cindy], locations: %w[SF NYC]`) 


### Spec Helpers

* Use `step` to break up a long feature spec:

```ruby
step "log in" do
  fill_in "Email", with: "alice@example.com"
  fill_in "Password", with: "password"
  click_button "Subnit"
end
```

* Use `wut` (or `save_and_open_preview`) to open a browser window at a particluar point in your test. If your local
  server is running, it will show the page with full styling (thanks to the `FilePreviewsController` which is only
  routable in the development and test environments).

* Use `with_modified_env` to modify an env variable for one test:
 
```ruby 
with_modified_env INVITATION_CODE: "inv-code", INVITATIONS_ENABLED: "true" do
  post :create, user: { name: "Alice", invitation_code: "wrong-code" }
  expect(flash[:alert]).to equal "Invalid invitation code"
end  
```

* Use `match_html` to test that two HTML strings match, excluding whitespace, order of attributes, etc.:

```ruby
expect(rendered).to match_html <<-HTML
  <table class="foo bar">
    <tr>
      <td>Hi!</td>
    </tr>
  </table>
HTML
```
