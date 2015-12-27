
require 'spec_helper'

describe 'bjjcollective::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

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
  
end
