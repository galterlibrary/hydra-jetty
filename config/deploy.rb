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
set :linked_files, ['resources/jetty-users.properties']

namespace :config do
end

namespace :jetty do
  desc 'Start Jetty'
  task :start do
    on roles(:app) do
      execute(
        "(cd #{release_path} && nohup java -jar start.jar > std.out 2>&1 &) && sleep 1",
        pty: true
      )
      puts 'Success here does not have to mean that the app has actually started...'
    end
  end

  desc 'Stop Jetty'
  task :stop do
    on roles(:app) do
      execute("cd #{release_path} && java -jar start.jar --stop")
    end
  end
end
