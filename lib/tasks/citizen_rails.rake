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
  end

  def create_server(server_name, remote_name)
    unless quiet_system("heroku apps:create #{server_name} --remote #{remote_name}")
      puts "error creating server #{server_name}, bailing!"
      exit 1
    end
    puts "Created #{server_name} with remote #{remote_name}"
  end

  def exists?(name)
    quiet_system("heroku apps:info --app #{name}")
  end

  def quiet_system(cmd)
    system("#{cmd} 2&>1 /dev/null")
  end
end
