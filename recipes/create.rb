
include_recipe '::default'


#symfony2インストーラー　インストール
execute 'symfony2 installer install' do
  user 'root'
  group 'root'
  command <<"EOC"
    curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
    sudo chmod a+x /usr/local/bin/symfony
EOC
  not_if {File.exist?('/usr/local/bin/symfony')}
end

#symfony2インストール
execute 'symfony2 install' do
  user #{default['symfony2']['maintenance']['user']}
  group #{default['symfony2']['maintenance']['group']}
  command "symfony new #{node[ :symfony2 ][ :path ]} #{node[ :symfony2 ][ :version ]}"
  not_if {File.directory?(node[ :symfony2 ][ :path ])}
end

#ドキュメントルート書き換え
set_document_root node[ :symfony2 ][ :path ] + '/web' do
end

#開発用マシンからapp_dev.phpにアクセス許可設定
if node[:symfony2][:develop]
  execute 'remove 127.0.0.1 from app_dev.php' do
    user #{default['symfony2']['maintenance']['user']}
    group #{default['symfony2']['maintenance']['group']}
    command "sed -i 's/127.0.0.1/#{node[ :symfony2 ][:maintenance][:hostip]}/' #{node[:symfony2][:path]}/web/app_dev.php"
    only_if "grep '127.0.0.1' #{node[:symfony2][:path]}/web/app_dev.php"
  end
end

execute 'オーナー変更' do
  command "sudo chown -R #{node['symfony2']['maintenance']['user']}:#{node['symfony2']['maintenance']['group']} #{node[:symfony2][:path]}"
end
execute '権限変更' do
  command "sudo chmod -R 755 #{node[:symfony2][:path]}"
end
