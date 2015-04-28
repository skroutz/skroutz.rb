require 'spec_helper'

describe Skroutz::Favorite do
  include_context 'resource'

  let(:attributes) { {} }

  subject(:favorite) { described_class.new(attributes, client) }

  describe 'associations' do
    subject { described_class.associations }

    it { is_expected.to include :sku }
  end
end
