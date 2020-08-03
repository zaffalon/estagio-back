# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'zagu-estagio-back'
# set :repo_url, 'git@ballista.com.br:zagu_api.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/rails_apps/zagu_api'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty,  false

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :rails_env, 'production'
set :deploy_via, :copy

set :normalize_asset_timestamps, %{public/images}

set :sidekiq_log, File.join('log', 'sidekiq.log')

set :sidekiq_pid, File.join('tmp', 'pids', 'sidekiq.pid')

# Delayed Jobs
# set :delayed_job_prefix, :mailer

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

#  desc "Start delayed jobs"
#  task :start_delayed_jobs, in: :sequence, wait: 5 do
 #   run "cd #{current_path}; RAILS_ENV=production bin/delayed_job stop"
 #   run "cd #{current_path}; RAILS_ENV=production bin/delayed_job start"
 # end

  # after :publishing, :restart do
#   invoke 'delayed_job:restart'
# end

#  after :restart, :start_delayed_jobs

  after :restart, :cleanup

end
