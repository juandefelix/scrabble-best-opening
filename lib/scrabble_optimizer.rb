require 'rubygems'
require 'bundler/setup'


require "json"
require "pry-byebug"

class ScrabbleOptimizer

	def initialize(path)
		@values_hash = {}
		@quants_hash = Hash.new(0)
		@available_words = []
		@board = []
binding.pry
		file = File.read(path)
		file_hash = JSON.parse(file, symbolize_names: true)

		make_hashes(file_hash)
		find_words(file_hash)
		make_board(file_hash)
	end

	def get_winner_board_hash
		winner_board_hash = { word: nil, row: nil, index: nil, value: 0 }
		@available_words.each do |word|
			word_result = lookup_word(word)
			if word_result[:value] > winner_board_hash[:value]
				winner_board_hash[:word] = word
				winner_board_hash.update(word_result)
			end
		end
		winner_board_hash
	end

	# private

	# finds wich row is best for a word
	def lookup_word(word)
		winner_board = { row: nil, index: nil, value: 0, direction: nil }

		@board.each_with_index do |row, i|
			row_result = lookup_row(word, row, i)
			if row_result[:value] > winner_board[:value]
				winner_board[:row] = i
				winner_board[:direction] = 'horizotal'
				winner_board.update(row_result)
			end
		end

		# find_best_vertical
		@board.transpose.each_with_index do |row, i|
			best_in_row = lookup_row(word, row, i)
			if best_in_row[:value] > winner_board[:value]
				winner_board[:row] = i
				winner_board.update(best_in_row)
				winner[:direction] = 'vertical'

				#transpose values
				row = winner_board[:row]
				index = winner_board[:index]
				winner_board[:row] = index
				winner_board[:index] = row
			end
		end
		winner_board
	end

	#finds wich place in a row is best
	def lookup_row(word, row, row_index)
		winner_index = { index: nil, value: 0 }

		last_place = row.size - word.size

		(0..last_place).each do |n|
			best_index = get_points(word, row[n...n+word.size])
			if best_index > winner_index[:value]
				winner_index[:value] = best_index
				winner_index[:index] = n
			end
		end
		winner_index
	end

	def get_points(word, board_fragment)
		points = 0
		word.chars.each_with_index do |ch, i|
			points += @values_hash[ch] * board_fragment[i]
		end 
		points
	end

	def make_hashes(file_hash)
		tiles = file_hash[:tiles]

		tiles.each do |tile|
			letter = tile[0]
			value = tile[1..-1]

			@values_hash[letter] = value.to_i
			@quants_hash[letter] += 1
		end
	end

	def find_words(file_hash)
		words = file_hash[:dictionary]
		words.each { |word| @available_words << word if word_available?(word) }
	end

	def word_available?(word)
		quants = @quants_hash.dup
		word.chars.each do |char|
			if quants[char] > 0
				quants[char] -= 	1
			else
				return false
			end
		end
		true
	end

	def make_board(file_hash)
		raw_board =file_hash[:board]
		@board = raw_board.map { |row| row.split(" ").map!(&:to_i) }
	end
end

so = ScrabbleOptimizer.new("INPUT.json")
# p so.get_winner_board_hash
p so.get_points('aa', [1, 1])