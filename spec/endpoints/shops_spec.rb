require 'spec_helper'

describe 'shops' do
  include_context 'resource'

  subject(:shops) { client.shops }

  it_behaves_like 'a resource', only: :find do
    let(:resource) { shops }
  end
end
