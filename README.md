# README

This project is built on top of [Citizen Rails](https://github.com/citizencode/citizen-rails). 
See [README-citizen-rails-template.md](README-citizen-rails-template.md) for instructions on
using the Citizen Rails template project as a base for your own project.

## Getting Started

After cloning this repo, run: `bin/setup`


## Day-to-day

Make sure everything is up to date: `bin/update`

Run tests: `rails spec`

Push: `bin/pushit`


## Debugging

Call `byebug` anywhere in the code to stop execution and get a debugger console.
Access an IRB console on exception pages or by using `<%= console %>` anywhere in the code.


## What's Included

### Simple User Authorization

There are 3 user levels: admin, member, and guest. Admins are users whose `admin` flag is set.
Members are users who aren't admins. Guests are non-logged-in visitors.

By default, only admins are authorized to call a controller action. To let other user levels
in, override the `allowed` method in your controller to return a hash of actions and user levels:

    def allowed
      { 
        index: :admin, # only admins
        show: :member, # admins and members
        new: :guest, # admins, members, and non-logged-in visitors (everyone)
      }
    end
    

