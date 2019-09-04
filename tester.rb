require 'colorize'
require 'colorized_string'

# ColorizedString.colors                       # return array of all possible colors names
# ColorizedString.modes                        # return array of all possible modes
  # ColorizedString.color_samples                # displays color samples in all combinations
# ColorizedString.disable_colorization         # check if colorization is disabled
# ColorizedString.disable_colorization = false # enable colorization
# ColorizedString.disable_colorization false   # enable colorization
# ColorizedString.disable_colorization = true  # disable colorization
# ColorizedString.disable_colorization true    # disable colorization
puts ColorizedString["                              This is blue text on red                                "].cyan.on_light_white
# puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
# puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)