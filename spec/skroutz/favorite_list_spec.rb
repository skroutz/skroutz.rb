require 'spec_helper'

describe Skroutz::Resources::FavoriteList do
  include_context 'resource'

  let(:attributes) { {} }

  subject(:favorite_list) { described_class.new(attributes, client) }

  describe 'associations' do
    subject { described_class.associations }

    it { is_expected.to include :favorites }
  end
end
