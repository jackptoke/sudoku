# frozen_string_literal: true
# require_relative 'gui'
require 'artii'
require 'terminal-table'
require 'colorize'
require 'colorized_string'

module Gui
  # this function is to give user option of what they want to do
  def self.display_option1
    rows = []
    rows << ['1. I\'m up for a sudoku challenge']
    rows << ['2. Solve a sudoku from a csv file']
    rows << ['9. Exit']

    table = Terminal::Table.new title: ColorizedString['****************Hello!****************'].cyan.on_light_white, rows: rows, style: { width: 72 }
    a = Artii::Base.new font: 'slant'
    puts a.asciify('Sudoku Master')
    puts table
    print 'Enter your option number: '
    input = STDIN.gets.strip
    input
  end

  # This function is when user opt in to play
  # It allows user to input values into the cells
  def self.cell_input_display
    rows = []
    rows << ['[ROW COL VALUE]:eg.: 6 5 9']
    rows << ['Or enter: 0 0 0 if you give up.']
    table = Terminal::Table.new title: ColorizedString['****************Game On****************'].cyan.on_light_white, rows: rows, style: { width: 90 }
    puts table
    print 'Enter: '
    input_values = STDIN.gets.strip.split(' ').map(&:to_i)
    input_values
  end

  # When a game has been successfully attempted
  # User will get to see congratulation message
  def self.congratulate
    a = Artii::Base.new font: 'slant'
    puts a.asciify('Congratulation!!')
  end

  def self.difficulty_level
    valid = false
    input_value = 0
    until valid do
      puts `clear`
      a = Artii::Base.new font: 'slant'
      puts a.asciify('Sudoku Master')
      rows = []
      rows << ['Difficulty Level']
      rows << ['1. Easy']
      rows << ['2. Intermediate']
      rows << ['3. Expert']
      table = Terminal::Table.new title: ColorizedString['*******Sudoku Master*********'].cyan.on_light_white, rows: rows, style: { width: 70 }
      puts table
      print 'Enter (1-3): '
      input_value = STDIN.gets.strip
      if /[1-3]/.match(input_value) && input_value.to_i <= 3  && input_value.to_i >= 1 
        valid = true
      end
    end
    return input_value.to_i
  end
end

# class Test
#   include Gui
#   def initialize()
#   end
# end

# t = Test.new
# Gui.difficulty_level
# Gui.congratulate
