require 'spec_helper'

describe Skroutz::CollectionProxy do
  let(:id) { nil }
  let(:client) { double(:client) }
  let(:owner) { nil }
  let(:class_name) { 'FruitsCollection' }

  context 'when initialized directly' do
    subject { described_class.new(id, client, owner) }

    it 'raises RuntimeError' do
      expect { subject }.
        to raise_error(RuntimeError, 'Attempted to initialize an abstract class')
    end
  end

  context 'when initialized from a child class' do
    subject(:proxy) { Class.new(described_class).new(id, client, owner) }

    describe 'initialization' do
      it 'sets id' do
        expect(subject.id).to eql(id)
      end

      it 'sets client' do
        expect(subject.client).to eql(client)
      end

      it 'sets owner' do
        expect(subject.owner).to eq(owner)
      end
    end

    describe '#resource' do
      before do
        allow(proxy).to receive_message_chain('class.to_s').and_return(class_name)
      end

      subject { proxy.resource }

      it { is_expected.to eq('fruit') }
    end

    describe '#resource_prefix' do
      before do
        allow(proxy).to receive_message_chain('class.to_s').and_return(class_name)
      end

      subject { proxy.resource_prefix }

      it { is_expected.to eq('fruits') }
    end

    describe '#model_name' do
      let(:class_name) { 'ExoticFruitsCollection' }
      let(:resource) { 'exotic_fruit' }
      let(:resource_class) { double(:resource) }

      before do
        allow(proxy).to receive(:resource).and_return(resource)
        stub_const("Skroutz::#{resource.classify}", resource_class)
      end

      subject { proxy.model_name }

      it { is_expected.to eql(resource_class) }
    end

    describe 'direct association methods' do
      let(:options) { {} }
      let(:id) { 42 }
      let(:association) { :seeds }
      let(:resource_prefix) { 'fruits' }

      subject { proxy.send(association, options) }

      before do
        allow(proxy).to receive(:resource_prefix).and_return(resource_prefix)
        allow(proxy).to receive(:parse)
      end

      it 'points to the correct endpoint' do
        expect(client).
          to receive(:get).with("/#{resource_prefix}/#{id}/#{association}", options)

        subject
      end

      context 'when called with a block' do
        let(:response) { double(:response) }

        before { allow(client).to receive(:get).and_return(response) }

        it 'yields the raw response' do
          expect(proxy).to receive(association).and_yield(response)

          proxy.send(association, options) { |_| }
        end
      end

      context 'when url_prefix option is present' do
        let(:options) { { url_prefix: 'edible' } }

        it 'prepends it the the request path' do
          expect(client).
            to receive(:get).
            with("#{options[:url_prefix]}/#{resource_prefix}/#{id}/#{association}", options)

          subject
        end
      end

      describe 'request verb' do
        context 'when verb option is present' do
          let(:options) { { verb: :put } }

          it 'performs the request with the verb specified' do
            expect(client).
              to receive(options[:verb]).
              with("/#{resource_prefix}/#{id}/#{association}", options)

            subject
          end
        end

        context 'when via option in present' do
          let(:options) { { via: :put } }

          it 'performs the request with the verb specified' do
            expect(client).
              to receive(options[:via]).
              with("/#{resource_prefix}/#{id}/#{association}", options)

            subject
          end
        end
      end
    end
  end
end
