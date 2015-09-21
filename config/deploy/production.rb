set :stage, :production

server 'vfsmghslrepo01.fsm.northwestern.edu', user: 'deploy', roles: %w{app db web}
set :ssh_options, {
  forward_agent: true,
}
