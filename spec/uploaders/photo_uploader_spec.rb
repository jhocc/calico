require 'rails_helper'

describe PhotoUploader do
  let(:photo_uploader) { described_class.new }

  it 'store photo to /images/profile_photo/:id/:version/:file_name' do
    allow(photo_uploader).to receive(:model).and_return(double(:model, id: 'id'))
    allow(photo_uploader).to receive(:mounted_as).and_return('photo_uploads')

    expect(photo_uploader.store_dir).to eq 'assets/images/photo_uploads/id/'
  end

  describe '#default_url' do
    it 'generate url to avatar path' do
      user = double(:user, name: 'John Doe').as_null_object
      allow(photo_uploader).to receive(:model).and_return user
      expect(photo_uploader).to receive_message_chain(:url_helpers, :send)
        .with(:avatar_path, 350, anything, 'John Doe')
        .and_return('/url')

      expect(photo_uploader.default_url).to eq('/url')
    end

    it 'use different color for public_user' do
      public_user = double(:public_user, name: 'John Doe', role: Role::PUBLIC)
      allow(photo_uploader).to receive(:model).and_return public_user
      expect(photo_uploader).to receive_message_chain(:url_helpers, :send)
        .with(:avatar_path, 350, described_class::AVATAR_COLORS[Role::PUBLIC], 'John Doe')
        .and_return('/url')

      expect(photo_uploader.default_url).to eq('/url')
    end

    it 'use different color for case_worker' do
      case_worker = double(:public_user, name: 'John Doe', role: Role::CASE_WORKER)
      allow(photo_uploader).to receive(:model).and_return case_worker
      expect(photo_uploader).to receive_message_chain(:url_helpers, :send)
        .with(:avatar_path, 350, described_class::AVATAR_COLORS[Role::CASE_WORKER], 'John Doe')
        .and_return('/url')

      expect(photo_uploader.default_url).to eq('/url')
    end

    it 'use different size for small iamge' do
      public_user = double(:public_user, name: 'John Doe', role: Role::PUBLIC)
      allow(photo_uploader).to receive(:model).and_return public_user
      allow(photo_uploader).to receive(:version_name).and_return :small
      expect(photo_uploader).to receive_message_chain(:url_helpers, :send)
        .with(:avatar_path, 75, described_class::AVATAR_COLORS[Role::PUBLIC], 'John Doe')
        .and_return('/url')

      expect(photo_uploader.default_url).to eq('/url')
    end
  end
end
