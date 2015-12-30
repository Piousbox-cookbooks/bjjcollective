#
# Cookbook   bjjcollective::default
# Recipe     default
#
# Copyright 2015, Wasya.co
#
# _vp_ 20151229
#
# MIT license
#

include_recipe "ish::upstream_rails"
include_recipe "ish_apache::install_apache"

app              = data_bag_item('apps', 'bjjcollective')
app['deploy_to'] = "/home/#{app['user'][node.chef_environment]}/projects/#{app['id']}"
owner            = app['user'][node.chef_environment]

#
# custom virtual site for the whole app
#
template "/etc/apache2/sites-available/#{app['id']}.conf" do
  source "etc/apache2/sites-available/bjjc_site.conf.erb"
  owner  owner
  group  owner
  mode   "0664"
  variables(
    :listen_port      => app['listen_port'][node.chef_environment],
    :appserver_port   => app['appserver_port'][node.chef_environment],
    :angular_port     => app['angular_port'][node.chef_environment]
  )
end


#
# custom virtual site for technique/ endpoint
#
template "/etc/apache2/sites-available/#{app['id']}-angular.conf" do
  source "etc/apache2/sites-available/bjjc_angular_site.conf.erb"
  owner  owner
  group  owner
  mode   "0664"
  variables(
    :listen_port => app['angular_port'][node.chef_environment],
    :document_root => "#{app['deploy_to']}/current/public_angular"
  )
end

[ app['listen_port'], app['angular_port'] ].each do |port_hash|
  port = port_hash[node.chef_environment]
  execute "open port #{port}" do
    command %{ echo "\nListen #{port}" >> /etc/apache2/ports.conf }
    not_if { ::File.read("/etc/apache2/ports.conf").include?("Listen #{port}") }
  end
end
## There are no named virtual hosts for bjjc. _vp_ 20151230
# execute "open this port 2" do
#   command %{ echo "\nNameVirtualHost *:#{site['port']}" >> /etc/apache2/ports.conf }
#   not_if { ::File.read("/etc/apache2/ports.conf").include?("NameVirtualHost *:#{site['port']}") }
# end

execute "enable_apache_angular_site" do
  command "a2ensite bjjcollective-angular"
end

execute "enable_apache_site" do
  command "a2ensite bjjcollective"
end

service "apache2" do
  action :restart
end
