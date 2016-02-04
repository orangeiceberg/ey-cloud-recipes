#
# Cookbook Name:: nginx_ember_rails
# Recipe:: default
#

directory '/data/thompson/shared/system/emberapp' do
  owner node[:users][0][:username]
  group node[:users][0][:username]
  mode 0755
end

template '/data/nginx/servers/thompson.conf' do
  backup 10
  source "nginx_ember_rails.conf"
  mode 0644
end

execute "sudo /etc/init.d/nginx reload"
