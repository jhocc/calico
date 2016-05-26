require 'rails_helper'

describe StateHelper do
  describe '#us_states' do
    it 'returns US states' do
      expect(helper.us_states).to include(['Alabama', 'AL'])
      expect(helper.us_states).to include(['New York', 'NY'])
      expect(helper.us_states).to include(['Wyoming', 'WY'])
    end
  end
end
