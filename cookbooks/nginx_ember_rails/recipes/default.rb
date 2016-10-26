require 'ostruct'
#
# Cookbook Name:: nginx_ember_rails
# Recipe:: default
#

# variables
app = node.engineyard.environment.apps.first
vhost = app[:vhosts].first
our_vhost = ::OpenStruct.new({
  name: app[:name],
  domain_name: vhost[:domain_name],
  app_type: "rails"
})
upstream_ports = params[:upstream_ports]
nginx_http_port = 80
nginx_https_port = 443
ssh_username = node.engineyard.environment.ssh_username

directory '/data/thompson/shared/system/emberapp' do
  owner ssh_username
  group ssh_username
  mode 0755
end

template '/data/nginx/servers/thompson.conf' do
  owner ssh_username
  group ssh_username
  mode 0644
  source "nginx_ember_rails.conf.erb"
  variables({
    :app_name => our_vhost.name,
    :vhost => our_vhost,
    :port => nginx_http_port,
    :upstream_ports => upstream_ports,
    :framework_env => node.environment.framework_env
  })
end

template '/data/nginx/servers/thompson.ssl.conf' do
  owner ssh_username
  group ssh_username
  mode 0644
  source "nginx_ember_rails.conf.erb"
  variables({
    :app_name => our_vhost.name,
    :vhost => our_vhost,
    :port => nginx_https_port,
    :upstream_ports => upstream_ports,
    :framework_env => node.environment.framework_env,
    :ssl => true
  })
end

execute "sudo /etc/init.d/nginx reload"
