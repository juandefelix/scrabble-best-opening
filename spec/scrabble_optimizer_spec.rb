require File.expand_path('../../lib/scrabble_optimizer.rb', __FILE__)

RSpec.describe ScrabbleOptimizer do

  before do
    p filename = File.expand_path('../../lib/INPUT.json', __FILE__)
    @so = ScrabbleOptimizer.new(filename)
  end 

  describe "get_points method" do
    expec(@so.get_points('aa', [1, 1])).to eq 4
  end
end