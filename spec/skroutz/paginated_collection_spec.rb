require 'spec_helper'

describe Skroutz::PaginatedCollection do
  let(:client_id) { 'a valid client_id' }
  let(:client_secret) { 'a valid client_secret' }
  let(:config_options) { {} }
  let(:client) { Skroutz::Client.new(client_id, client_secret, config_options) }

  let(:body) { {} }
  let(:headers) { {} }
  let(:response) { double(body: body.to_json, headers: headers) }
  let(:collection) { [] }
  let(:context) { double(client: client) }
  let(:pagination_meta) do
    {
      meta: {
        total_results: 100,
        total_pages: 4,
        page: 1,
        per: 25
      }
    }
  end

  subject(:paginated_collection) { described_class.new(context, response, collection) }

  describe 'initialization' do
    it 'sets context' do
      expect(subject.context).to eql(context)
    end

    it 'sets response' do
      expect(subject.response).to eql(response)
    end

    it 'sets collection' do
      expect(subject).to eq(collection)
    end
  end

  describe '#first_page?' do
    subject { paginated_collection.first_page? }

    context 'when the current page is the first' do
      let(:headers) do
        {
          'link' => '<https://api.skroutz.gr/categories?page=41per=5>; rel="next",'\
                    '<https://api.skroutz.gr/categories?page=42&per=5>; rel="last"'
        }
      end

      it 'returns true' do
        is_expected.to be
      end
    end

    context 'when the current page is not the first' do
      let(:headers) do
        {
          'link' => '<https://api.skroutz.gr/categories?page=1per=5>; rel="first",'\
                    '<https://api.skroutz.gr/categories?page=2&per=5>; rel="previous",'\
                    '<https://api.skroutz.gr/categories?page=4&per=5>; rel="next",'\
                    '<https://api.skroutz.gr/categories?page=42&per=5>; rel="last"'
        }
      end

      it 'returns true' do
        is_expected.to_not be
      end
    end
  end

  describe '#last_page?' do
    subject { paginated_collection.last_page? }

    context 'when the current page is the last' do
      let(:headers) do
        {
          'link' => '<https://api.skroutz.gr/categories?page=1per=5>; rel="first",'\
                    '<https://api.skroutz.gr/categories?page=2&per=5>; rel="previous",'\
                    '<https://api.skroutz.gr/categories?page=3&per=5>; rel="next"'
        }
      end

      it 'returns true' do
        is_expected.to be
      end
    end

    context 'when the current page is not the last' do
      let(:headers) do
        {
          'link' => '<https://api.skroutz.gr/categories?page=41per=5>; rel="next",'\
                    '<https://api.skroutz.gr/categories?page=42&per=5>; rel="last"'
        }
      end

      it 'returns false' do
        is_expected.not_to be
      end
    end
  end

  describe '#first_page' do
    let(:target_page_uri) { 'https://api.skroutz.gr/categories?page=41per=5' }
    let(:body) { { categories: [] }}
    let(:headers) do
      {
        'link' => "<#{target_page_uri}>; rel=\"first\","\
                  '<https://api.skroutz.gr/categories?page=42&per=5>; rel="last"'
      }
    end

    subject { paginated_collection.first_page }

    context 'when there is a first page' do
      before { allow(paginated_collection).to receive(:first?).and_return(true) }

      it 'makes a get request using the client of the context' do
        expect(context).to receive(:get).and_return(response)

        subject
      end

      it 'performs a request for this page' do
        expect(context).to receive(:get).with(target_page_uri, {}).and_return(response)

        subject
      end

      it 'returns a Skroutz::PaginatedCollection' do
        allow(context).to receive(:get).and_return(response)

        is_expected.to be_a(Skroutz::PaginatedCollection)
      end
    end

    context 'when there is not a first page' do
      before { allow(paginated_collection).to receive(:first?).and_return(false) }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end

  describe '#last_page' do
    let(:target_page_uri) { 'https://api.skroutz.gr/categories?page=42per=5' }
    let(:body) { { categories: [] }}
    let(:headers) do
      {
        'link' => "<#{target_page_uri}>; rel=\"last\","\
                  '<https://api.skroutz.gr/categories?page=1&per=5>; rel="first"'
      }
    end

    subject { paginated_collection.last_page }

    context 'when there is a last page' do
      before { allow(paginated_collection).to receive(:last?).and_return(true) }

      it 'makes a get request using the client of the context' do
        expect(context).to receive(:get).and_return(response)

        subject
      end

      it 'performs a request for this page' do
        expect(context).to receive(:get).with(target_page_uri, {}).and_return(response)

        subject
      end

      it 'returns a Skroutz::PaginatedCollection' do
        allow(context).to receive(:get).and_return(response)

        is_expected.to be_a(Skroutz::PaginatedCollection)
      end
    end

    context 'when there is not a last page' do
      before { allow(paginated_collection).to receive(:last?).and_return(false) }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end

  describe '#next_page' do
    let(:target_page_uri) { 'https://api.skroutz.gr/categories?page=3per=5' }
    let(:body) { { categories: [] }}
    let(:headers) do
      {
        'link' => "<#{target_page_uri}>; rel=\"next\","\
                  '<https://api.skroutz.gr/categories?page=42&per=5>; rel="last"'
      }
    end

    subject { paginated_collection.next_page }

    context 'when there is a next page' do
      it 'makes a get request using the client of the context' do
        expect(context).to receive(:get).and_return(response)

        subject
      end

      it 'performs a request for this page' do
        expect(context).to receive(:get).with(target_page_uri, {}).and_return(response)

        subject
      end

      it 'returns a Skroutz::PaginatedCollection' do
        allow(context).to receive(:get).and_return(response)

        is_expected.to be_a(Skroutz::PaginatedCollection)
      end
    end

    context 'when there is no next page' do
      before { allow(paginated_collection).to receive(:next?).and_return(false) }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end

  describe '#previous_page' do
    let(:target_page_uri) { 'https://api.skroutz.gr/categories?page=2per=5' }
    let(:body) { { categories: [] }}
    let(:headers) do
      {
        'link' => "<#{target_page_uri}>; rel=\"previous\","\
                  '<https://api.skroutz.gr/categories?page=42&per=5>; rel="last"'
      }
    end

    subject { paginated_collection.previous_page }

    context 'when there is previous page' do
      it 'makes a get request using the client of the context' do
        expect(context).to receive(:get).and_return(response)

        subject
      end

      it 'performs a request for this page' do
        expect(context).to receive(:get).with(target_page_uri, {}).and_return(response)

        subject
      end

      it 'returns a Skroutz::PaginatedCollection' do
        allow(context).to receive(:get).and_return(response)

        is_expected.to be_a(Skroutz::PaginatedCollection)
      end
    end

    context 'when there is no previous page' do
      before { allow(paginated_collection).to receive(:previous?).and_return(false) }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end

  describe '#meta' do
    subject { paginated_collection.meta }

    context 'when there is a meta key in the response' do
      let(:body) { pagination_meta }

      it 'returns a HashWithIndifferentAccess' do
        is_expected.to be_a(HashWithIndifferentAccess)
      end

      it 'returns its contents' do
        is_expected.to eq(HashWithIndifferentAccess.new(pagination_meta[:meta]))
      end
    end

    context 'when there is not a meta key in the response' do
      it 'returns an empty Hash' do
        is_expected.to be_empty
      end
    end
  end
end
