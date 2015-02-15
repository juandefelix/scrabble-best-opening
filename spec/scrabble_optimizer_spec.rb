require File.expand_path('../../lib/scrabble_optimizer.rb', __FILE__)

RSpec.describe ScrabbleOptimizer do

  before(:context) do 
    filename = File.expand_path('../../lib/INPUT.json', __FILE__)
    @so = ScrabbleOptimizer.new(filename) 
  end

  describe "get_points method" do
    it 'returns expected value with all tiles with value 1' do
      expect(@so.get_points('aa', [1, 1])).to eq 4
    end

    it 'returns expected value with all tiles with value 2' do
      expect(@so.get_points('aa', [2, 2])).to eq 8
    end

    it 'returns expected value with tiles with different values' do
      expect(@so.get_points('aa', [4, 7])).to eq 22
    end
  end

  describe "lookup_row method" do
    it 'returns expected value in a simple row' do
      filename = File.expand_path('../../lib/INPUT.json', __FILE__)
      expect(@so.lookup_row('aa', [1, 1, 2, 1], 1)[:index]).to eq 1
    end

    it 'returns expected value in a complex row' do
      filename = File.expand_path('../../lib/INPUT.json', __FILE__)
      expect(@so.lookup_row('aa', [1, 2, 7, 5, 1], 1)[:index]).to eq 2
    end
  end
end