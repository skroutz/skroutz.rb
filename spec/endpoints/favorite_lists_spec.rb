require 'spec_helper'

describe 'favorite_lists' do
  include_context 'resource'

  subject(:favorite_lists) { client.favorite_lists }

  it_behaves_like 'a resource', only: :all do
    let(:resource) { favorite_lists }
  end
end
