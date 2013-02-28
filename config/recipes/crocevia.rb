namespace :crocevia do
  
  desc "Dependencies for libvips"
  task :dependencies, roles: :app do
    run "#{sudo} apt-get -y update"

    #run "#{sudo} apt-get -y install sqlite3 libsqlite3-dev"
    
    #run "#{sudo} apt-get -y install libmagick++-dev"
    run "#{sudo} apt-get -y install libvips-dev"

    run "gem install capistrano"
    run "gem install ruby-vips -v '0.3.5'"

    run "gem install taps --no-ri --no-rdoc"
    #run "gem install rmagick --no-ri --no-rdoc"
    run "gem install sqlite3 --no-ri --no-rdoc"
    run "gem install pg --no-ri --no-rdoc"
  end
  after "deploy:setup", "crocevia:dependencies"

  desc "Generate the application.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/application.yml"), "#{shared_path}/config/application.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "crocevia:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "crocevia:symlink"

end