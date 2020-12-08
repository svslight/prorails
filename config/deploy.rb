# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "prorails"
set :repo_url, "git@github.com:svslight/prorails.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/prorails"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

after 'deploy:publishing', 'unicorn:restart'
