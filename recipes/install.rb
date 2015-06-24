
include_recipe '::default'

execute 'symfony2インストール' do
  user #{default['symfony2']['maintenance']['user']}
  group #{default['symfony2']['maintenance']['group']}
  cwd node[:symfony2][:path]
  command 'composer install'
end

#ドキュメントルート書き換え
set_document_root node[ :symfony2 ][ :path ] + '/web' do
end

execute 'オーナー変更' do
  command "sudo chown -R #{node['symfony2']['maintenance']['user']}:#{node['symfony2']['maintenance']['group']} #{node[:symfony2][:path]}"
end
execute '権限変更' do
  command "sudo chmod -R 755 #{node[:symfony2][:path]}"
end

bash 'cache log ディレクトリ権限変更' do
  code <<-EOH
      setfacl -R -m u:#{node['symfony2']['execute_user']}:rwx -m u:#{node['symfony2']['maintenance']['user']}:rwx #{node['symfony2']['path']}/app/cache #{node['symfony2']['path']}/app/logs
      setfacl -dR -m u:#{node['symfony2']['execute_user']}:rwx -m u:#{node['symfony2']['maintenance']['user']}:rwx #{node['symfony2']['path']}/app/cache #{node['symfony2']['path']}/app/logs
  EOH
  only_if node[ :symfony2 ][ :acl ]
end
