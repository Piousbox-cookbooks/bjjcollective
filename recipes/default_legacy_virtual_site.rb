
#
# the 000-default.conf that throws all the traffic to the old http://bjjcollective.com
#

appserver_node = search(:node, "role:bjjcollective AND chef_environment:#{node.chef_environment}").first

template "/etc/apache2/sites-available/000-default.conf" do
  source "etc/apache2/sites-available/000-default.conf.erb"
  variables({
              :appserver_port => data_bag_item('apps', 'bjjcollective')['listen_port'][node.chef_environment],
              :ipaddress => appserver_node.ipaddress
            })
end

execute "a2ensite 000-default"

service "apache2" do
  action :restart
end

