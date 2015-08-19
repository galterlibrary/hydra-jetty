# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'galter_hydra_jetty'
set :use_sudo, false
set :format, :pretty
set :log_level, :debug
set :pty, true

# SVC stuff
if ARGV[1] =~ /^deploy/
  puts "Current Branch: #{`git rev-parse --abbrev-ref HEAD`.chomp}"
  puts "Current Tag: #{`git describe --always --tag`.chomp}"
  ask :branch, proc { `git describe --always --tag`.chomp }
end
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :ssh_user, "deploy"
set :repo_url, 'git@github.com:galterlibrary/hydra-jetty.git'
set :deploy_via, :remote_cache

# Paths
set :keep_releases, 3
set :deploy_to, "/var/www/apps/#{fetch(:application)}"
set :linked_dirs, [
  'logs', 'solr/data', "solr/#{fetch(:stage)}-core/data", 'fcrepo4-data'
]

namespace :config do
  desc 'Link the file with secrets'
  task :jetty_users do
    on roles(:app) do
      execute(
        :ln, '-sf',
        "#{fetch(:deploy_to)}/secrets/jetty-users.properties",
        "#{release_path}/resources/"
      )
    end
  end
end

namespace :jetty do
  desc 'Start Jetty'
  task :start do
    on roles(:app) do
      execute("cd #{release_path} && java -jar start.jar")
    end
  end
end

after 'deploy:publishing', 'config:jetty_users'
