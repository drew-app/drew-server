require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  subject(:get_index) { get :index }

  describe '#authenticate' do
    let(:jwt_token) { 'SOME_JWT_TOKEN' }
    let(:jwt_token_hash) { Hash[some: 'hash'] }
    let!(:service) { instance_double(Auth0Service) }

    before do
      allow(Auth0Service).to receive(:new).and_return(service)
    end

    context 'successful authentication' do
      before do
        expect(service).to receive(:decode_jwt).with(jwt_token).and_return(jwt_token_hash)

        request.headers['Authorization'] = "Bearer #{jwt_token}"
      end

      it { get_index; expect(response).to be_successful }
    end

    context 'no token' do
      before do
        expect(service).to_not receive(:decode_jwt)
      end

      it { expect { get_index }.to raise_error(AuthenticationError) }
    end

    context 'cannot decode token' do
      before do
        expect(service).to receive(:decode_jwt).with(jwt_token).and_raise(AuthenticationError.new('Bad decode for some reason'))

        request.headers['Authorization'] = "Bearer #{jwt_token}"
      end

      it { expect { get_index }.to raise_error(AuthenticationError) }
    end
  end
end
