require 'spec_helper'

describe 'categories' do
  include_context 'resource'

  subject(:categories) { client.categories }

  it_behaves_like 'a resource' do
    let(:resource) { categories }
  end
end
