require 'getoptlong'

require_relative 'hap/driver'

module Hap

  def self.usage(script_name)
    puts "Usage: #{script_name} [-h] [-o OUTPUT] PIECE"
    puts ""
    puts "Generate a MIDI file from a piece description."
    puts ""
    puts "Arguments:"
    puts "  PIECE\ta piece description file."
    puts ""
    puts "Options:"
    puts "  -h, --help            print this help messge."
    puts "  -o, --output OUTPUT   write midi to this file."
  end

  def self.main(script_name)
    opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--output', '-o', GetoptLong::OPTIONAL_ARGUMENT ]
    )
   
    output = nil
    opts.each do |opt, arg|
      case opt
        when '--help'
          return Hap.usage script_name
        when '--output'
          output = arg
      end
    end
    
    if ARGV.length != 1
      puts "Missing file argument (try --help)"
      exit 0
    end
    
    source = ARGV.shift
    if ! File.exists? source
      puts "piece file not found: #{source}"
      return
    end

    if output.nil?
      d = File.dirname(source)
      f = File.basename(source)
      output = File.join(d, "#{f}.mid")

    end

    driver = Driver.new
    driver.load source
    driver.convert_to_midi output
    puts "MIDI written to to #{output}"
  end

end