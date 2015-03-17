require 'spec_helper'

describe 'skus' do
  include_context 'resource'

  subject(:skus) { client.skus }

  it_behaves_like 'a resource', only: [:find] do
    let(:resource) { skus }
  end
end
