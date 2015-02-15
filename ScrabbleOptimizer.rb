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

		file = File.read(path)
		file_hash = JSON.parse(file, symbolize_names: true)

		make_hashes(file_hash)
		find_words(file_hash)
		make_board(file_hash)
	end

	def get_winner_board
		winner_board = { word: nil, row: nil, index: nil, value: 0 }
		@available_words.each do |word|
			word_result = find_best_board_for_word(word)
			if word_result[:value] > winner_board[:value]
				winner_board[:word] = word
				winner_board.update(word_result)
			end
		end
		winner_board
	end

private

	# finds wich row is best
	def find_best_board_for_word(word)
		winner_board = { row: nil, index: nil, value: 0, direction: nil }

		@board.each_with_index do |row, i|
			best_in_row = find_best_in_row(word, row, i)
			if best_in_row[:value] > winner_board[:value]
				winner_board[:row] = i
				winner_board[:direction] = 'horizotal'
				winner_board.update(best_in_row)
			end
		end

		# find_best_vertical
		@board.transpose.each_with_index do |row, i|
			best_in_row = find_best_in_row(word, row, i)
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
	def find_best_in_row(word, row, row_index)
		winner_index = { index: nil, value: 0 }

		last_place = row.size - word.size
		row_chunks = []

		(0..last_place).each do |n|
			new_value = get_points(word, row[n...n+word.size])
			if new_value > winner_index[:value]
				winner_index[:value] = new_value
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
	each_with_index
end

so = ScrabbleOptimizer.new("INPUT.json")
p so.get_winner_board
