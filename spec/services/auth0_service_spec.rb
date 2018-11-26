require 'rails_helper'

RSpec.describe Auth0Service do

  let(:certificate_mock) { double() }
  # NOTE: 90% of this class is 3rd party copy/pasted code. The unit tests only really test error
  # conditions. Full testing is handled via integration tests

  subject(:service) { Auth0Service.new }

  describe '.public_key_for_jwk_kid' do
    let(:jwks) { [
      {
        'alg' => 'RS256',
        'kty' => 'RSA',
        'use' => 'sig',
        'x5c' => ['SOMEPUBLICKEYENCODEDTHING'],
        'kid' => 'THEKEYID',
      }
    ] }

    before do
      Rails.cache.clear
      allow(service).to receive(:json_web_keys).and_return(jwks)
      allow(service).to receive(:extract_public_key).and_return('SOMEDECODEDPUBLICCERT')
      allow(certificate_mock).to receive(:public_key).and_return('SOMEDECODEDPUBLICKEY')
      allow(OpenSSL::X509::Certificate).to receive(:new).with('SOMEDECODEDPUBLICCERT').
        and_return(certificate_mock)
    end

    it 'should return the public key for a valid kid' do
      expect(service.public_key_for_jwk_kid('THEKEYID')).to eq('SOMEDECODEDPUBLICKEY')
    end

    it 'should raise an exception if there is not a public key for the keyid' do
      expect { service.public_key_for_jwk_kid 'BULLSHIT' }.to raise_error(AuthenticationError)
    end
  end
end
