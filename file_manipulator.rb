#custom exception to signal bad data
class BadFileFormatException < StandardError  
  def initialize(msg)
    super(msg)
    @msg = msg
  end
  def to_s
    @msg
  end
end 

module FileManipulator

  #Load a sudoku from a File
  #return the content in 2D array
  #the function also check to make sure that all the datas are valid
  def load_sudoku_from_file(filename)
    sudoku_game = []
    begin
      File.open(filename, 'r').each do |line|
        sudoku_game << line.strip.split(',').map{|value| value.to_i}
        if !is_soduku_format(sudoku_game[-1])
          raise BadFileFormatException.new("Incorrect file format.")
        end
      end

    rescue BadFileFormatException
      puts "The format of the data is incorrect/incomplete/plain wrong."
    rescue StandardError => e 
      puts e.message  
      puts e.backtrace.inspect  
    end
    return sudoku_game
  end  

  def load_batch_sudokus_from_file(filename)
    sudoku_game = []
    
    begin
      File.open(filename, 'r').each do |line|
        str = line.strip.split(',')[0]
        str.gsub!(/[.]/,'0')
        puts str
        game = []
        i = 0
        if str.size > 81
          raise BadFileFormatException.new("Incorrect file format.")
        end
        while i < str.size
          row = []
          c = 0
          while c < 9
            row << str[i]
            c += 1
            i += 1
          end
          if !is_soduku_format(row)
            raise BadFileFormatException.new("Incorrect file format.")
          end
          game << row
        end
        sudoku_game << game
        # p game
      end
    rescue BadFileFormatException
      puts "The format of the data is incorrect/incomplete/plain wrong."
    rescue StandardError => e 
      puts e.message  
      puts e.backtrace.inspect  
    end
    return sudoku_game
  end

  #check the content of the file
  #if the data row is not exactly 9 in length
  #or if the value of the data is not within the range of 1 to 9
  #it's not a valid soduku data
  def is_soduku_format(row)
    if row.size != 9
      return false
    end
    row.each do |value| 
      if value.to_i < 0 || value.to_i > 9
        return false
      end
    end
    return true
  end
end

class Test
  include FileManipulator
  def initialize()
  end
end

test = Test.new()
games = test.load_batch_sudokus_from_file('easy-sudokus.csv')
games.each do |game|
  game.each do |row|
    p row
  end
  puts "End"
end
# p test.load_sudoku_from_file("sudoku1.csv")
# p test.load_sudoku_from_file("sudoku2.csv")