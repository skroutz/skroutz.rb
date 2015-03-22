require 'spec_helper'

describe 'manufacturers' do
  include_context 'resource'

  subject(:manufacturers) { client.manufacturers }

  it_behaves_like 'a resource' do
    let(:resource) { manufacturers }
  end
end
