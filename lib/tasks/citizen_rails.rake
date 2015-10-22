namespace :citizen_rails do
  desc "Creates Staging and Production servers"
  task :configure_heroku_servers, [:project_name] do |t, args|
    create_stack(args[:project_name])
  end

  def create_stack(name)
    staging_name = "#{name}-staging"
    prod_name = "#{name}-prod"

    if exists?(staging_name) || exists?(prod_name)
      puts "Sorry, either the staging or prod version of that app exists! Try a new name"
      exit 1
    end

    create_server(staging_name, "staging")
    create_server(prod_name, "prod")

    replace_strings("company_name")
    replace_strings("project_description")
    replace_strings("contact_email")
  end

  def replace_strings(string)
    puts "Please enter your #{string}:"
    new = STDIN.gets.chomp
    system("ruby -pi -e 'gsub(/###{string}##/, \"#{new}\")' config/application.rb")
  end

  def create_server(server_name, remote_name)
    unless heroku_command("heroku apps:create #{server_name} --remote #{remote_name}")
      puts "error creating server #{server_name}, bailing!"
      exit 1
    end
    puts "Created #{server_name} with remote #{remote_name}"
    provision_server(server_name)
  end

  def provision_server(app)
    heroku_command("heroku addons:create heroku-postgresql:hobby-dev --app #{app}")
    heroku_command("heroku addons:create postmark:10k --app #{app}")
    puts <<-EOL
\n\n
****************************************************************
TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
Run `heroku addons:open postmark:10k --app #{app}`
and create your first sender signature
****************************************************************
\n\n
EOL
    heroku_command("heroku addons:create airbrake:free_heroku --app #{app}")
  end

  def exists?(name)
    heroku_command "heroku apps:info --app #{name}"
  end

  def heroku_command(command)
    Bundler.with_clean_env { system(command) }
  end
end
