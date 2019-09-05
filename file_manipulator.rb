# frozen_string_literal: true

# custom exception to signal bad data
class BadFileFormatException < StandardError
  def initialize(msg)
    super(msg)
    @msg = msg
  end

  def to_s
    @msg
  end
end

# take batch data and split them into various files
# each file containing the data for a game
module FileManipulator
  def split_and_save_datas(datas)
    count = 1
    datas.each do |game_data|
      filename = "intermediate-game-#{count}.csv"
      begin
        File.open(filename, 'w') do |f|
          game_data.each do |row|
            str = row.to_s.gsub(/[ ]/, '').delete '[]'
            f.puts str
          end
        end
      rescue StandardError => e
        puts e.message
        puts e.backtrace.inspect
      end
      count += 1
    end
  end

  # Load a sudoku from a File
  # return the content in 2D array
  # the function also check to make sure that all the datas are valid
  def load_sudoku_from_file(filename)
    sudoku_game = []
    begin
      File.open(filename, 'r').each do |line|
        sudoku_game << line.strip.split(',').map(&:to_i)
        unless is_soduku_format(sudoku_game[-1])
          raise BadFileFormatException, 'Incorrect file format.'
        end
      end
    rescue BadFileFormatException
      puts 'The format of the data is incorrect/incomplete/plain wrong.'
    rescue StandardError => e
      puts e.message
      puts e.backtrace.inspect
    end
    sudoku_game
  end

  # the function is for loading a batch file containing many games
  # and return the datas in it
  def load_batch_sudokus_from_file(filename)
    sudoku_game = []

    begin
      File.open(filename, 'r').each do |line|
        str = line.strip.split(',')[0]
        str.gsub!(/[.]/, '0')
        # puts str
        game = []
        i = 0
        raise BadFileFormatException, 'Incorrect file format.' if str.size > 81

        while i < str.size
          row = []
          c = 0
          while c < 9
            row << str[i].to_i
            c += 1
            i += 1
          end
          unless is_soduku_format(row)
            raise BadFileFormatException, 'Incorrect file format.'
          end

          game << row
        end
        sudoku_game << game
        # p game
      end
    rescue BadFileFormatException
      puts 'The format of the data is incorrect/incomplete/plain wrong.'
    rescue StandardError => e
      puts e.message
      puts e.backtrace.inspect
    end
    sudoku_game
  end

  # check the content of the file
  # if the data row is not exactly 9 in length
  # or if the value of the data is not within the range of 1 to 9
  # it's not a valid soduku data
  def is_soduku_format(row)
    return false if row.size != 9

    row.each do |value|
      return false if value.to_i < 0 || value.to_i > 9
    end
    true
  end
end

class Test
  include FileManipulator
  def initialize; end
end

test = Test.new
games = test.load_batch_sudokus_from_file('intermediate-sudoku.csv')
test.split_and_save_datas(games)
# p test.load_sudoku_from_file("intermediate-game-2.csv")
# games.each do |game|
#   game.each do |row|
#     p row
#   end
#   puts "End"
# end
# p test.load_sudoku_from_file("sudoku1.csv")
# p test.load_sudoku_from_file("sudoku2.csv")
