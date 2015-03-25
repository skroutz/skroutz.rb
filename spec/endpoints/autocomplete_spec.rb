require 'spec_helper'

describe 'autocomplete' do
  include_context 'resource'

  let(:query) { 'iphone' }
  let(:options) { {} }
  let(:request_stub) do
    stub_with_fixture(:get,
                      'autocomplete',
                      'autocomplete').with(query: { q: query })
  end

  subject(:autocomplete) { client.autocomplete(query, options) }

  before { request_stub }

  it 'performs a get request' do
    expect(client).to receive(:get).and_call_original

    subject
  end

  it 'targets the correct path' do
    expect(client).to receive(:get).with('autocomplete', q: query).and_call_original

    subject
  end

  describe 'the returned resource' do
    it 'is an instance of the proper class' do
      is_expected.to be_a Skroutz::PaginatedCollection
    end
  end

  it_behaves_like 'an error handled request' do
    let(:request) { subject }
    let(:request_stub) { stub_get('autocomplete').with(query: { q: query }) }
  end
end
