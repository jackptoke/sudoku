require 'artii'

module GUI
  #this function is to give user option of what they want to do
  def display_option1
    rows = []
    rows << ['1. I\'m up for a sudoku challenge']
    rows << ['2. Solve a sudoku from a csv file']
    rows << ['9. Exit']

    table = Terminal::Table.new :title => ColorizedString["****************Sudoku Master****************"].cyan.on_light_white, :rows => rows, :style => {:width => 50}
    puts table
    print 'Enter your option number: '
    input = STDIN.gets.strip
    return input
  end

  #This function is when user opt in to play
  #It allows user to input values into the cells
  def cell_input_display
    rows = []
    rows << ["To enter a value for a cell follow the format. (row col value)"]
    rows << ["E.g. to enter the value of 9 to the cell on row 6 and column 5, you enter: 6 5 9"]
    rows << ["Or enter: 0 0 0 if you give up."]
    table = Terminal::Table.new :title => ColorizedString["****************Sudoku Master****************"].cyan.on_light_white, :rows => rows, :style => {:width => 100}
    puts table
    print 'Enter cell value: '
    input_values = STDIN.gets.strip.split(' ').map {|val| val.to_i}
    return input_values
  end
  
  #When a game has been successfully attempted
  #User will get to see congratulation message
  def congratulate
    a = Artii::Base.new :font => 'slant'
    puts a.asciify('Congratulation!!')
  end
end

# class Test
#   include GUI
#   def initialize()
#   end
# end

# t = Test.new
# t.congratulate
