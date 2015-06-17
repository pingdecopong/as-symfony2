require 'serverspec'

set :backend, :exec

describe command('curl localhost/app_dev.php') do
  its(:stdout) { should match /No route found/ }
end

