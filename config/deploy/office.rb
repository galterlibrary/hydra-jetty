set :stage, :staging

server '192.168.122.71', user: 'deploy', roles: %w{app db web}
set :ssh_options, {
  proxy: Net::SSH::Proxy::Command.new('ssh deploy@165.124.124.30 -W %h:%p'),
  forward_agent: true,
}
