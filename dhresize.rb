#!/usr/bin/env ruby
require 'rubygems'
require 'RMagick'
require 'thread'
include ObjectSpace

# Resize a directory of images.
# ./dhresize.rb "/Users/dave/Desktop/Portland Trip" 50
# Above example would resize all pics 50% in "Portland Trip" folder.
# Images would be saved to "/Users/dave/Desktop/Portland Trip/resized/"

$start_time = Time.now

PATH = ARGV[0]
SCALE = ARGV[1].to_f

RESIZED_IMAGES = File.join(PATH, "resized")
THUMBS = File.join(PATH, "resized", "thumbs")

Dir.mkdir(RESIZED_IMAGES) unless File.exists?(RESIZED_IMAGES)
Dir.mkdir(THUMBS) unless File.exists?(THUMBS)

def create_thumb(image)
  thumb = image.crop_resized(240, 180, Magick::NorthGravity)
  thumb.write(File.join(THUMBS, "thumb_" + File.basename(image.filename)))  
  puts "Saved thumb for #{File.basename(image.filename)}"
end

def scale_image(image)
  resized_image = image.scale(SCALE * 0.01)
  resized_image.write(File.join(RESIZED_IMAGES, File.basename(image.filename)))
  puts "Saved scaled image for #{File.basename(image.filename)}"
end

threads = []

Dir.entries(PATH).each do |file|
  threads << Thread.new(file) {|this_file|
    begin
      image = Magick::Image::read(File.join(PATH, file)).first
      scale_image(image)
      create_thumb(image)
    rescue Exception => e
      puts e.inspect
    end
    ObjectSpace.garbage_collect
  }
end

threads.each {|x| 
  puts "Joining new thread..."
  x.join
}
puts "Operation finished in #{Time.now - $start_time}"