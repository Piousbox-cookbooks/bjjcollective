
require 'spec_helper'

describe 'bjjcollective::default' do
  
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['cookbook']['attribute'] = 'hello'
      node.default['apache2'] = {}
    end.converge(described_recipe)
  end

  before :each do
    stubbed_apps = [
      { :id => 'one' },
      { :id => 'two' },
      { :id => 'three' }
    ]
    stub_search("apps", "*:*").and_return(stubbed_apps)
  end
  
  it 'installs curl' do
    expect(chef_run).to install_package('curl')
  end
  
  it 'runs ish::upstream_rails' do
    expect(chef_run).to include_recipe 'ish::upstream_rails'
  end
  
end
