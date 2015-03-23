require 'spec_helper'

describe Skroutz::Client do
  let(:client_id) { 'a valid client_id' }
  let(:client_secret) { 'a valid client_secret' }
  let(:config_options) { {} }

  subject(:client) { Skroutz::Client.new(client_id, client_secret, config_options) }

  describe '#client_id' do
    subject { client.client_id }

    it 'returns the value passed at initialization' do
      is_expected.to eq(client_id)
    end
  end

  describe '#client_id=' do
    let(:new_client_id) { 'new client id' }

    it 'sets the @client_id' do
      expect {
        client.client_id = new_client_id
      }.to change { client.client_id }.from(client_id).to(new_client_id)
    end
  end

  describe '#client_secret' do
    subject { client.client_secret }

    it 'returns the value passed at initialization' do
      is_expected.to eq(client_secret)
    end
  end

  describe '#client_secret=' do
    let(:new_client_secret) { 'new client secret' }

    it 'sets the @client_secret' do
      expect {
        client.client_secret = new_client_secret
      }.to change { client.client_secret }.from(client_secret).to(new_client_secret)
    end
  end

  describe '#config' do
    subject(:config) { client.config }

    context 'when none is supplied' do
      it { is_expected.to eq(Skroutz::Default.to_hash) }
    end

    context 'when a configuration option is supplied' do
      context 'and a default exists' do
        let(:config_options) { { user_agent: 'netscape' } }
        subject { config[:user_agent] }

        it 'overrides the default' do
          is_expected.to eq config_options[:user_agent]
        end
      end

      context 'and a default does not exist' do
        let(:config_options) { { a_config_option: 'something' } }
        subject { config[:a_config_option] }

        it 'is set to the supplied value' do
          is_expected.to eq config_options[:a_config_option]
        end
      end
    end
  end

  describe '#conn' do
    before { allow(client).to receive(:application_token).and_return('token') }

    subject { client.conn }

    it 'returns a Faraday::Connection' do
      is_expected.to be_a(Faraday::Connection)
    end
  end

  describe 'resource methods' do
    it { is_expected.to respond_to :categories }
    it { is_expected.to respond_to :skus }
    it { is_expected.to respond_to :products }
    it { is_expected.to respond_to :shops }
    it { is_expected.to respond_to :manufacturers }
    it { is_expected.to respond_to :filter_groups }
    it { is_expected.to respond_to :favorites }
    it { is_expected.to respond_to :notifications }
  end

  describe '#conn' do
    before { allow(client).to receive(:token) }
    subject(:conn) { client.conn }

    it 'returns a Faraday connection' do
      is_expected.to be_a(Faraday::Connection)
    end
  end

  describe '#token' do
    before { expect(client).to receive(:application_token) }
    subject { client.token }

    it 'acquires an application token' do
      subject
    end
  end
end
