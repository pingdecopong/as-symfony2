
include_recipe '::default'

execute 'symfony2インストール' do
  user #{default['symfony2']['maintenance']['user']}
  group #{default['symfony2']['maintenance']['group']}
  cwd node[:symfony2][:path]
  command 'composer install'
end

execute 'オーナー変更' do
  command "sudo chown -R #{node['symfony2']['maintenance']['user']}:#{node['symfony2']['maintenance']['group']} #{node[:symfony2][:path]}"
end
execute '権限変更' do
  command "sudo chmod -R 755 #{node[:symfony2][:path]}"
end
