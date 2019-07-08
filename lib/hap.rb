require_relative 'config'
require_relative 'markov/chain'

module Hap

  class Hap

    @config = nil

    def initialize
    end

    def load(src)
      puts src
      # u = Config::Part.new do |p|
      #   p.title = 'Wombat'
      #   p.tempo = 78
      #   p.clips = [
      #       Config::Clip.new do |c|
      #       c.events = [
      #           Config::Event.new do |e|
      #           e.note = :a
      #           e.dynamic = :mf
      #           e.duration = :quaver
      #           end
      #       ]
      #       end
      #     ]
      # end
    
      # puts u.inspect

      Config::Part.new do |p|
      end
    end

    def convert_to_midi(dest)
    end

  end
end