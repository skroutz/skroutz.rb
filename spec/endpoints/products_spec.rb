require 'spec_helper'

describe 'products' do
  include_context 'resource'

  subject(:products) { client.products }

  it_behaves_like 'a resource', only: :find do
    let(:resource) { products }
  end
end
