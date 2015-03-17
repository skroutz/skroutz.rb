shared_examples 'a resource' do |options|
  describe '#find' do
    let(:resource_id) { 42 }
    let(:request_stub) do
      stub_with_fixture(:get,
                        "#{resource.base_path}/#{resource_id}",
                        "#{resource.base_path}_show")
    end

    subject { resource.find(resource_id) }

    before { request_stub }

    it 'performs a get request' do
      expect(resource.client).to receive(:get).and_call_original

      subject
    end

    it 'targets the correct path' do
      expect(resource.client).
        to receive(:get).with("#{resource.base_path}/#{resource_id}").and_call_original

      subject
    end

    describe 'returned resource' do
      it 'is an instance of the proper class' do
        is_expected.to be_a resource.model_name
      end
    end

    it_behaves_like 'an error handled request' do
      let(:request) { subject }
      let(:request_stub) { stub_get("#{resource.base_path}/#{resource_id}") }
    end
  end if !options || options[:only].include?(:find)

  describe '#page' do
    let(:per) { 10 }
    let(:pagenum) { 2 }

    let(:request_stub) do
      stub_with_fixture(:get,
                        resource.base_path,
                        "#{resource.base_path}_index").with(query: { page: pagenum,
                                                                     per: per })
    end

    subject { resource.page(pagenum, per: per) }

    before { request_stub }

    it 'performs a get request' do
      expect(resource.client).to receive(:get).and_call_original

      subject
    end

    it 'targets the correct path' do
      expect(resource.client).
        to receive(:get).with(resource.base_path, kind_of(Hash)).and_call_original

      subject
    end

    it 'targets the correct page' do
      expect(resource.client).
        to receive(:get).with(kind_of(String), page: pagenum, per: per).and_call_original

      subject
    end

    it 'sets the per query parameter' do
    end

    it_behaves_like 'an error handled request' do
      let(:request) { subject }
      let(:request_stub) do
        stub_get(resource.base_path).with(query: { page: pagenum, per: per })
      end
    end
  end if !options || options[:only].include?(:page)

  describe '#all' do
    subject { resource.all }

    let(:request_stub) do
      stub_with_fixture(:get, resource.base_path, "#{resource.base_path}_index")
    end

    before { request_stub }

    it 'performs a get request' do
      expect(resource.client).to receive(:get).and_call_original

      subject
    end

    it 'targets the correct path' do
      expect(resource.client).
        to receive(:get).with(resource.base_path).and_call_original

      subject
    end

    describe 'returned collection' do
      it 'is a SkroutzApi::PaginatedCollection' do
        is_expected.to be_a SkroutzApi::PaginatedCollection
      end

      it 'contains instances of the proper class' do
        is_expected.to all(be_an(resource.model_name))
      end
    end

    it_behaves_like 'an error handled request' do
      let(:request) { subject }
      let(:request_stub) { stub_get(resource.base_path) }
    end
  end if !options || options[:only].include?(:all)
end
