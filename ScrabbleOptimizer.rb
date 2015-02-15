require 'rubygems'
require 'bundler/setup'


require "json"
require "pry-byebug"

class ScrabbleOptimizer

	def initialize(path)
		file = File.read(path)
		file_hash = JSON.parse(file, symbolize_names: true)
		read_tiles(file_hash)
		# filter_words(file_hash)
		# read_board(file_hash)
	end

	def read_tiles(file_hash)
		@letter_hash = {}
		tiles = @file_hash[:tiles]

		tiles.each do |tile|
			letter = tile[0]
			value = tile[1..-1]

			@letter_hash[letter] ||= { value: 0, number: 0}

			@letter_hash[letter][:value] = value
			@letter_hash[letter][:number] += 1
		end
		binding.pry
	end

	def filter_words(file_hash)
		@words = []
		words = file_hash["dictionary"]
		words.each { |word| @words << word if is_available? word }
	end

	def is_available?(word)
		quants = @quants.dup
		word.chars.each do |char|
			if quants[char] > 0
				quants[char] -= 1
			else
				return false
			end
		end
		true
	end

	def read_board(file_hash)
		@board = file_hash["board"]
		@board.map! do |row|
			row.split(" ").map!(&:to_i)
		end
	end

	def brute_force_horizontal
		max_value = 0
		max_word = ""
		max_x = 0
		max_y = 0
		@words.each do |word|
			word_points = word.chars.map { |char| @points[char] }
			x, y, value = brute_force_word word_points
			if value > max_value
				max_value = value
				max_word = word
				max_x = x
				max_y = y
			end
		end
	end

	def brute_force_word(word)
		max_index = 0
		max_row = 0
		max_value = 0
		@board.each_with_index do |row, row_index|
			(0..row.length - word.length).each do |col|
				value = brute_force_hor_index word, row, col
				if value > max_value
					max_col = col
					max_row = row_index
					max_value = value
				end
			end
		end
		[max_row, max_index, max_value]
	end

	def brute_force_hor_index(word, row, index)
		board = row[0 + index ... word.length + index]
		(0...word.count).inject(0) {|r, i| r + word[i]*board[i]}
	end

end

so = ScrabbleOptimizer.new("./EXAMPLE_INPUT.json")
so.brute_force_hor_index([2, 3, 4], [1, 1, 1, 1, 2, 3, 4, 1, 1, 1], 4)