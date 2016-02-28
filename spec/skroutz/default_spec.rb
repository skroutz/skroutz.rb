require 'spec_helper'

describe Skroutz::Default do
  let(:client_id) { 'a valid client_id' }
  let(:client_secret) { 'a valid client_secret' }
  let(:config_options) { {} }

  subject(:defaults) { Skroutz::Default }

  describe '#to_hash' do
    subject { defaults.to_hash }

    context 'when no arguments are passed' do
      it 'returns defaults for skroutz' do
        expect(subject[:api_endpoint]).to eql('https://api.skroutz.gr')
      end
    end

    context 'when nil flavor is passed' do
      subject { defaults.to_hash(flavor: nil) }

      it 'returns defaults for skroutz' do
        expect(subject[:api_endpoint]).to eql('https://api.skroutz.gr')
      end
    end

    context 'when an unknown flavor is passed' do
      subject { defaults.to_hash(flavor: :unknown) }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error ArgumentError, "Missing flavor: unknown"
      end
    end

    context 'when a known flavor is passed' do
      subject { defaults.to_hash(flavor: :alve) }

      it 'returns defaults for the specified flavor' do
        expect(subject[:api_endpoint]).to eql('https://api.alve.com')
      end
    end
  end
end
