shared_examples 'an error handled request' do
  let(:response) { request_stub.to_return(status: status) }

  before { response }

  describe '4XX class' do
    describe '404 Not Found' do
      let(:status) { 404 }

      it 'raises SkroutzApi::ResourceNotFound' do
        expect { request }.to raise_error(SkroutzApi::ResourceNotFound)
      end
    end

    describe '410 Gone' do
      let(:status) { 410 }

      it 'raises SkroutzApi::ResourceNotFound' do
        expect { request }.to raise_error(SkroutzApi::ResourceNotFound)
      end
    end
  end

  describe '5XX class' do
    describe '500 Internal Server Error' do
      let(:status) { 500 }

      it 'raises SkroutzApi::ServerError' do
        expect { request }.to raise_error(SkroutzApi::ServerError)
      end
    end
  end

  describe 'response timeout' do
    let(:response) { request_stub.to_timeout }

    it 'raises SkroutzApi::TimeoutError' do
      expect { request }.to raise_error(SkroutzApi::TimeoutError)
    end
  end
end
