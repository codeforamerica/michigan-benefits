# Using Citizen Rails As A Template For A New Rails App

## Create the project

Create a new project, and set the Citizen Rails repo as a remote:

    mkdir your-new-project
    cd your-new-project
    git init
    git remote add citizen-rails git@github.com:citizencode/citizen-rails
    git fetch citizen-rails
    git reset --hard citizen-rails/master
    git remote add origin git@github.com:[organization/project-name]
    
    
You can keep `citizen-rails` as a remote to pull new changes from `citizen-rails` into your project. At some point,
your project and `citizen-rails` will probably diverge too much to be able to pull new changes in.


## Configure the project

1. Edit `application.rb` and change the module name and configuration settings.
1. Edit the database names in `database.yml`
1. Search the project for the word `citizen` to find other things to change.


## Get started

    bin/setup
    citizen doctor
    

## Importing changes from Citizen Rails

See what's changed: 
    
    git fetch citizen-rails
    git log citizen-rails/master
    
Merge all changes from the Citizen Rails:

    git merge citizen-rails/master
        
