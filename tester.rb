# frozen_string_literal: true

require_relative 'game'
require_relative 'file_manipulator'

# solve
solve('sudoku2.csv')
# play
# play
p prepare_sudoku_cells
FileManipulator.load_sudoku_from_file('sudoku2.csv')
