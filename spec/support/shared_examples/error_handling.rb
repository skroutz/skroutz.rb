shared_examples 'an error handled request' do
  let(:response) { request_stub.to_return(status: status) }

  before { response }

  describe '4XX class' do
    describe '400 Bad Request' do
      let(:status) { 400 }

      it 'raises Skroutz::ClientError' do
        expect { request }.to raise_error(Skroutz::ClientError)
      end
    end

    describe '401 Unauthorized' do
      let(:status) { 401 }

      it 'raises Skroutz::UnauthorizedError' do
        expect { request }.to raise_error(Skroutz::UnauthorizedError)
      end
    end

    describe '403 Forbidden' do
      let(:status) { 403 }

      describe 'rate-limiting' do
        context 'when the remaining hits are less than 0' do
          let(:response) do
            request_stub.to_return(status: status,
                                   headers: { 'X-RateLimit-Remaining' => -1 })
          end

          it 'raises Skroutz::RateLimitingError' do
            expect { request }.to raise_error(Skroutz::RateLimitingError)
          end
        end

        context 'when the remaining hits are 0' do
          let(:response) do
            request_stub.to_return(status: status,
                                   headers: { 'X-RateLimit-Remaining' => 0 })
          end

          it 'raises Skroutz::RateLimitingError' do
            expect { request }.to raise_error(Skroutz::RateLimitingError)
          end
        end

        context 'when not exceeded' do
          let(:response) do
            request_stub.to_return(status: status,
                                   headers: { 'X-RateLimit-Remaining' => 1 })
          end

          it 'raises Skroutz::ClientError' do
            expect { request }.to raise_error(Skroutz::ClientError)
          end
        end

        context 'when the rate-limiting headers are missing' do
          it 'does not raise' do
            expect { request }.to raise_error(Skroutz::ClientError)
          end
        end
      end
    end

    describe '404 Not Found' do
      let(:status) { 404 }

      it 'raises Skroutz::ResourceNotFound' do
        expect { request }.to raise_error(Skroutz::ResourceNotFound)
      end
    end

    describe '410 Gone' do
      let(:status) { 410 }

      it 'raises Skroutz::ResourceNotFound' do
        expect { request }.to raise_error(Skroutz::ResourceNotFound)
      end
    end
  end

  describe '5XX class' do
    describe '500 Internal Server Error' do
      let(:status) { 500 }

      it 'raises Skroutz::ServerError' do
        expect { request }.to raise_error(Skroutz::ServerError)
      end
    end
  end

  describe 'response timeout' do
    let(:response) { request_stub.to_timeout }

    it 'raises Skroutz::TimeoutError' do
      expect { request }.to raise_error(Skroutz::TimeoutError)
    end
  end
end
