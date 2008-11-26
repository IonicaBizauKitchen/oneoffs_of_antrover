#!/usr/bin/env ruby -wKU

# Extract the top 10 color hex codes from an image. 
# The output will look like this:

# 1436 - #000200
# 1409 - #010300
# 1246 - #000501
# 1217 - #000100
# 1033 - #000403
# 876 - #050C04
# 798 - #000000
# 790 - #020401
# 770 - #060D05
# 680 - #010602

# First column is the count, and the second column is the hex color.

require 'rubygems'
require 'RMagick'

# Open the image
# pic = Magick::ImageList.new("/Users/dave/Desktop/tiff_and_i_cooking.png")
pic = Magick::ImageList.new("/Users/dave/Desktop/black.jpg")

# Sort the histogram based on the count of the hex color
sorted = pic.color_histogram.sort {|a,b| b[1] <=> a[1]}

color_map = []

# Slice the first 10 records off. 
sorted.slice(0..9).each do |value|
  color = value[0].to_color(Magick::AllCompliance, false, Magick::QuantumDepth)
  color_map << {:count => value[1], :color_value => color}
end

color_map.each do |color|
  puts color[:count].to_s + " - " + color[:color_value]
end