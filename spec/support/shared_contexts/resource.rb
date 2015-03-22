shared_context 'resource' do
  let(:client_id) { 'a valid client_id' }
  let(:client_secret) { 'a valid client_secret' }
  let(:config_options) { {} }
  let(:client) { SkroutzApi::Client.new(client_id, client_secret, config_options) }

  before { allow(client).to receive(:application_token).and_return('token') }
end
