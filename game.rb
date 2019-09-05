# frozen_string_literal: true

require_relative 'cell'
require 'terminal-table'
require_relative 'file_manipulator'
require 'colorize'
require 'colorized_string'
require_relative 'gui'
require 'pry'

# include Gui
# include FileManipulator

# loading datas from files
# cell_values1 = FileManipulator.load_sudoku_from_file("sudoku1.csv")
# cell_values2 = FileManipulator.load_sudoku_from_file("sudoku2.csv")

# build the possible values of each cell
def build_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      next if cell.is_fixed

      cell.potential_value_stack = [1, 2, 3, 4, 5, 6, 7, 8, 9]

      # for each cell in the vertical
      cell.vertical_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.horizontal_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.block_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
    end
  end
end

# shed
def shed_potential_value_list(cells)
  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      next if cell.is_fixed
      # for each cell in the vertical
      cell.vertical_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.horizontal_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
      cell.block_family.each do |c|
        cell.potential_value_stack.delete_if { |value| value == cells[c[0]][c[1]].value }
      end
    end
  end
end

# evaluate and update
def update_cells(cells)
  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      if !cell.is_fixed && cell.potential_value_stack.size == 1
        cell.value = cell.potential_value_stack.pop
      end
    end
  end
end

# display the cells
def display_sudoku(cells, title)
  puts `clear`
  rows = []
  cells.each do |row|
    temp_row = []
    row.each do |cell|
      temp_row << { value: cell.value, alignment: :center }
    end
    rows << temp_row
  end

  table2 = Terminal::Table.new title: title, rows: rows, style: { width: 55, all_separators: true }

  puts table2
end

# solve the sudoku
def solved(cells)
  a_flag = true

  cells.each do |row|
    row.each do |cell|
      # all cell except the fixed one
      return false if cell.value.zero?
    end
  end

  a_flag
end

# The function will solve a sudoku from a given filename
def solve_a_sudoku(sudoku_datas)
  sudoku_cells = prepare_sudoku_cells(sudoku_datas)
  # display_sudoku(sudoku_cells, "Sudoku to solve")
  # build the potential list of values for each cell
  build_potential_value_list(sudoku_cells)
  update_cells(sudoku_cells) # update the value of each cell
  counter = 0
  # continue to the try to solve
  # if the counter goes beyond a million
  # it's probably a bad sudoku
  until solved(sudoku_cells) #
    shed_potential_value_list(sudoku_cells)
    update_cells(sudoku_cells)
    counter += 1
  end
  sudoku_cells
end

# get a list of all the sudoku cells that require attention
# they are to be shed as their values changes
def get_focus_cells(sudoku_cells)
  # look through the grid and put into the array
  # all the cells that still need attention

  # this method could possible implemented at the start
  # to reduce unnecessary check and improve performance
end

# Look for two or three cells in the same row, column or subgrid
# that have exactly the same values in their potential value lists
# if such cells are found, remove those values in all other cells
# that are not one of those cells
def double_or_triple_whammer(sudoku_cells)
  # 1. obtain the lists of cells that still need a value
  # 2. for each cell in the list look for other cells
  #   which are in the same row, column or subgrid
  #   that has the same potential values
  # 3. if such cells are found, remove from other
  #   cells all those values from them
end

def prepare_sudoku_cells(sudoku_datas)
  sudoku_cells = []
  sudoku_datas.each_with_index do |row, index_r|
    cell_row = []
    row.each_with_index do |value, index_c|
      cell_row << Cell.new(index_r, index_c, value)
    end
    sudoku_cells << cell_row
  end
  sudoku_cells
end

def user_interface
  go_play = true
  # files = ['sudoku1.csv', 'sudoku2.csv']
  # batch_file = 'easy-sudokus.csv'
  progress = 0 # keeping track of the game

  until go_play != true
    # puts "I'm here!!"
    input = Gui.display_option1
    if input == '1'
      play
      progress += 1
    elsif input == '2'
      # ask user for a file name
      print 'Please, enter the csv filename: '
      filename = STDIN.gets.strip
      solve(filename)

    elsif input == '9'
      # quit
      go_play = false
    else
      puts "We don't offer any other option.  Please, try again."
    end
  end
end

def play
  files = ['sudoku1.csv', 'sudoku2.csv']
  progress = Random.rand(0..(files.size - 1)) # keeping track of the game

  # play game
  sudoku_datas = FileManipulator.load_sudoku_from_file(files[progress])
  sudoku_cells = prepare_sudoku_cells(sudoku_datas)

  solution = solve_a_sudoku(sudoku_datas)
  until solved(sudoku_cells)
    # puts `clear`
    display_sudoku(sudoku_cells, "Sudoku Challenge ##{progress + 1}")
    input_values = Gui.cell_input_display # gets.strip.split(' ').map {|val| val.to_i}
    if !(!input_values.grep_v(1..9).empty? || input_values.size != 3)

      sudoku_cells[input_values[0] - 1][input_values[1] - 1].value = input_values[-1].to_i
    elsif input_values.count(0) == 3
      display_sudoku(solution, "Solution to Challenge ##{progress + 1}")
      break
    else
      puts "You've entered some invalid datas.  Try again."
    end
  end
  result = solved(sudoku_cells)
  if result
    Gui.congratulate
    puts 'You have successfully completed your challenge.'
  end
end

def solve(filename)
  if File.exist?(filename)
    cell_values2 = FileManipulator.load_sudoku_from_file(filename)
    # print out the solution
    result = solve_a_sudoku(cell_values2)
    puts `clear`
    display_sudoku(result, 'Solved by Sudoku Solver (programmed by Jack Toke)')
  else
    puts 'Invalid filename.  Please, try again later.'
  end
end

input_array, *the_rest = ARGV

# binding.pry

if input_array.nil?
  # user_interface
  # puts "I'm here"
  user_interface
elsif input_array.downcase == 'play'
  # play
  puts "Let's play"
  play
elsif input_array.downcase == 'solve'
  if !the_rest.empty?
    puts "Let's solve: #{the_rest}"
    if File.exist?(the_rest[0])
      # call the method to solve the sudoku
      puts 'Call the Solve method here.'
      solve(the_rest[0])
    else
      puts "Sudoku Master couldn't find the file you've specified."
    end
  else
    puts 'A filename is expected. Eg. sudoku.csv'
  end
end
