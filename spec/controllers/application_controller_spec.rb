require 'rails_helper'

describe ApplicationController do
  describe '#ssl_configured?' do
    it 'is enabled only for production environment' do
      environment = double('environment', production?: true)
      allow(Rails).to receive(:env) { environment }
      expect(described_class.new.ssl_configured?).to be_truthy
    end

    it 'is disabled for other environments' do
      environment = double('environment', production?: false)
      allow(Rails).to receive(:env) { environment }
      expect(described_class.new.ssl_configured?).to be_falsey
    end
  end
end
