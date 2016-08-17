# README

This project is built on top of [Citizen Rails](https://github.com/citizencode/citizen-rails). 
See [README-citizen-rails-template.md](README-citizen-rails-template.md) for instructions on
using the Citizen Rails template project as a base for your own project.

## Developing

### Getting Started

* After cloning this repo, run: `bin/setup`


### Day-to-day

* Make sure everything is up to date: `bin/update`
* Run the server: `rails s` and [http://localhost:3000](http://localhost:3000)
* Run tests: `rails spec`
* Push: `bin/pushit`


### Debugging

* Call `byebug` anywhere in the code to stop execution and get a debugger console.
* Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.
* (Of course, [RubyMine](https://www.jetbrains.com/ruby/) includes a great [visual debugger](https://www.jetbrains.com/ruby/features/ruby_debugger.html)).


## What's Included

### Simple User Authorization

There are 3 user levels: **admin**, **member**, and **guest**. **Admins** are users whose `admin` flag is set.
**Members** are users who aren't admins. **Guests** are non-logged-in visitors.

By default, only admins are authorized to call a controller action. To let other user levels
in, override the `allowed` method in your controller to return a hash of actions and user levels:

    def allowed
      { 
        index: :admin, # only admins
        show: :member, # admins and members
        new: :guest, # admins, members, and non-logged-in visitors (everyone)
      }
    end
    

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


### Feature Spec Helpers

* Use `step` to break up a long feature spec:

      step "log in" do
        fill_in "Email", with: "alice@example.com"
        fill_in "Password", with: "password"
        click_button "Subnit"
      end
* Use `wut` (or `save_and_open_preview`) to open a browser window at a particluar point in your test. If your local
  server is running, it will show the page with full styling (thanks to the `FilePreviewsController` which is only
  routable in the development and test environments).
