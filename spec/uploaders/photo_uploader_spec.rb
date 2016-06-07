require 'rails_helper'

describe PhotoUploader do
  let(:photo_uploader) { described_class.new }

  it 'store photo to /images/profile_photo/:id/:version/:file_name' do
    allow(photo_uploader).to receive(:model).and_return(double(:model, id: 'id'))
    allow(photo_uploader).to receive(:mounted_as).and_return('photo_uploads')

    expect(photo_uploader.store_dir).to eq 'assets/images/photo_uploads/id/'
  end

  it 'has default url for worker' do
    allow(photo_uploader).to receive(:model).and_return(double(:model, is_case_worker?: true))

    expect(photo_uploader.default_url).to eq '/assets/images/worker.svg'
  end

  it 'has default url for user' do
    allow(photo_uploader).to receive(:model).and_return(double(:model, is_case_worker?: false))

    expect(photo_uploader.default_url).to eq '/assets/images/user.svg'
  end
end
