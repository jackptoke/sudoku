module GUI

  def display_option1
    rows = []
    rows << ['1. I\'m up for a sudoku challenge']
    rows << ['2. Solve a sudoku from a csv file']
    rows << ['9. Exit']

    table = Terminal::Table.new :title => ColorizedString["****************Sudoku Master****************"].cyan.on_light_white, :rows => rows, :style => {:width => 50}
    puts table
    print 'Enter your option number: '
    input = gets.strip
    return input
  end

  def cell_input_display
    rows = []
    rows << ["To enter a value for a cell follow the format. (row col value)"]
    rows << ["E.g. to enter the value of 9 to the cell on row 6 and column 5, you enter: 6 5 9"]
    rows << ["Or enter: 0 0 0 if you give up."]
    table = Terminal::Table.new :title => ColorizedString["****************Sudoku Master****************"].cyan.on_light_white, :rows => rows, :style => {:width => 100}
    puts table
    print 'Enter cell value: '
    input_values = gets.strip.split(' ').map {|val| val.to_i}
    return input_values
  end
end