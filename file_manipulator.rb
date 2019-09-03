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
        sudoku_game << line.strip.split(',')
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

# test = Test.new()
# p test.load_sudoku_from_file("sudoku1.csv")
# p test.load_sudoku_from_file("sudoku2.csv")