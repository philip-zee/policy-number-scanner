require_relative '../lib/policy_ocr'

    # @file = File.readlines("./spec/fixtures/sample.txt").map(&:chomp)
    # @lines = @file.size / 4
    # @columns = @file.first.size / 3

describe PolicyOcr do
  let(:policy) { PolicyOcr }
  let(:file) { @file }

  before :context do
    @file = File.readlines("./spec/fixtures/sample.txt").map(&:chomp)
  end

  it "loads" do
    expect(PolicyOcr).to be_a Module
  end

  it 'loads the sample.txt' do
    expect(fixture('sample').lines.count).to eq(44)
  end

  it 'should assign sample.txt to @file' do
    expect(@file).to eq(File.readlines("./spec/fixtures/sample.txt").map(&:chomp))
  end

  it 'converts OCR to an array' do
    expect(policy.conversion(file)).to be_an_instance_of(Array)
  end

  it 'converts OCR to an integer in array' do
    expect(policy.conversion(file)[0]).to be_an_instance_of(Integer)
  end

  # it 'reads and injects each digit into a one line string' do
  #   expect(policy.policy_number)
  # end

  context 'converts OCR to appropriate number' do
    it 'recognizes 0' do
      expect(policy.conversion(file)[0]).to eq(0)
    end
    it 'recognizes 1' do
      expect(policy.conversion(file)[1]).to eq(111111111)
    end
    it 'recognizes 2' do
      expect(policy.conversion(file)[2]).to eq(222222222)    
    end
    it 'recognizes 3' do
      expect(policy.conversion(file)[3]).to eq(333333333)
    end
    it 'recognizes 4' do
      expect(policy.conversion(file)[4]).to eq(444444444)
    end
    it 'recognizes 5' do
      expect(policy.conversion(file)[5]).to eq(555555555)
    end
    it 'recognizes 6' do
      expect(policy.conversion(file)[6]).to eq(666666666)
    end
    it 'recognizes 7' do
      expect(policy.conversion(file)[7]).to eq(777777777)
    end
    it 'recognizes 8' do
      expect(policy.conversion(file)[8]).to eq(888888888)
    end
    it 'recognizes 9' do
      expect(policy.conversion(file)[9]).to eq(999999999)
    end
    it 'recognizes mixed numbers' do
      expect(policy.conversion(file)[10]).to eq(123456789)
    end
  end

end
