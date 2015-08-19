set :stage, :staging

server 'vtfsmghslrepo01.fsm.northwestern.edu', user: 'deploy', roles: %w{app db web}
set :ssh_options, {
  forward_agent: true,
}
