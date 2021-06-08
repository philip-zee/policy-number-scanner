# frozen_string_literal: true

require_relative '../lib/validator'

describe PolicyOcr::Validator do
  describe '#valid_check_sum?' do
    subject { described_class.new(account_number).valid_check_sum? }
    context 'valid check sum' do
      let(:account_number) { '345882865' }
      it { expect(subject).to eq true }
    end

    context 'invalid check sum' do
      let(:account_number) { '111111111' }
      it { expect(subject).to eq false }
    end
  end
end
