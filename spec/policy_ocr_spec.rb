require_relative '../lib/policy_ocr'

    # @file = File.readlines("./spec/fixtures/sample.txt").map(&:chomp)
    # @lines = @file.size / 4
    # @columns = @file.first.size / 3

describe PolicyOcr do
  let(:policy) { PolicyOcr.new }

  it "loads" do
    expect(PolicyOcr).to be_a Module
  end

  it 'loads the sample.txt' do
    expect(fixture('sample').lines.count).to eq(44)
  end

  # it '@file should be assigned sample.txt' do
  #   expect(@file).to eq(File.readlines("./spec/fixtures/sample.txt").map(&:chomp))
  # end

  # context 'converts OCR to appropriate number' do
  #   it 'recognizes 0' do
  #     expect(policy.conversion(file)).to eq(0)
  #   end
  #   it 'recognizes 1' do
  #     expect(policy.conversion(file)).to eq(1)
  #   end
  #   it 'recognizes 2' do
  #     expect(policy.conversion(file)).to eq(2)    
  #   end
  #   it 'recognizes 3' do
  #     expect(policy.conversion(file)).to eq(3)
  #   end
  #   it 'recognizes 4' do
  #     expect(policy.conversion(file)).to eq(4)
  #   end
  #   it 'recognizes 5' do
  #     expect(policy.conversion(file)).to eq(5)
  #   end
  #   it 'recognizes 6' do
  #     expect(policy.conversion(file)).to eq(6)
  #   end
  #   it 'recognizes 7' do
  #     expect(policy.conversion(file)).to eq(7)
  #   end
  #   it 'recognizes 8' do
  #     expect(policy.conversion(file)).to eq(8)
  #   end
  #   it 'recognizes 9' do
  #     expect(policy.conversion(file)).to eq(9)
  #   end
  # end

end
