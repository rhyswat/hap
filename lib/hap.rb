require_relative 'hap/driver'


module Hap

  def self.usage(script_name)
    puts type(script_name)
    puts script_name
  end

  def self.main(*args)
    driver = Driver.new
    driver.load 'examples/single-track'
    driver.convert_to_midi 'test.mid'
  end

end