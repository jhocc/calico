require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '.flash_messages' do
    it 'returns alert, notice and success flash message' do
      allow(helper).to receive(:flash).and_return({
        alert: [:alert_message],
        notice: [:notice_message],
        success: [:success_message],
        timeout: [true],
      })
      expect(helper.flash_messages)
        .to eq [:alert_message, :notice_message, :success_message]
    end
  end
end
