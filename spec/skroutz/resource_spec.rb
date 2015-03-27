require 'spec_helper'

describe Skroutz::Resource do
  let(:attributes) { {} }
  let(:client) { double(:client) }

  subject(:resource) { Skroutz::Resource.new(attributes, client) }

  describe '#attributes' do
    subject { resource.attributes }

    it 'returns the value passed at initialization' do
      is_expected.to eq(attributes)
    end
  end

  describe '#attributes=' do
    let(:new_attributes) { { paint: :blue } }

    it 'sets the @attributes' do
      expect {
        resource.attributes = new_attributes
      }.to change { resource.attributes }.from(attributes).to(new_attributes)
    end
  end

  describe '#client' do
    subject { resource.client }

    it 'returns the value passed at initialization' do
      is_expected.to eql(client)
    end
  end

  describe '#client=' do
    let(:new_client) { double(:new_client) }

    it 'sets the @client' do
      expect {
        resource.client = new_client
      }.to change { resource.client }.from(client).to(new_client)
    end
  end

  describe '#inspect' do
    subject { resource.inspect }

    context 'when attributes is present' do
      let(:attributes) { { first_name: 'John', last_name: 'Doe' } }

      it 'calls attribute_for_inspect for every attribute' do
        expect(resource).to receive(:attribute_for_inspect).
          exactly(attributes.keys.size).times

        subject
      end
    end

    context 'when attributes is not present' do
      it { is_expected.to eql("#<#{described_class} not initialized>") }
    end
  end

  describe 'attribute methods' do
    let(:attributes) { { 'name' => 'john', 'alive' => true, 'kicking' => false } }
    let(:attribute) { :name }

    subject(:method_call) { resource.public_send(attribute) }

    context 'when the attribute exists' do
      it 'responds to the attribute method' do
        expect(resource).to respond_to(attribute)
      end

      context 'predicates' do
        let(:attribute) { :alive? }

        context 'truthy value' do
          it 'returns true' do
            is_expected.to be
          end
        end

        context 'falsy value' do
          let(:attribute) { :kicking? }

          it 'returns false' do
            is_expected.to_not be
          end
        end
      end
    end

    context 'when the attribute does not exist' do
      let(:attribute) { :unicorn }

      it 'raises NoMethodError' do
        expect { method_call }.to raise_error(NoMethodError)
      end
    end
  end
end
