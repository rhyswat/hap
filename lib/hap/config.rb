require 'set'
require 'docile'

module Hap

    #
    # DSL helper
    # -----------------------------------------------------------------
    class ConfigReader
        def self.piece(&block)
            Docile.dsl_eval(PieceBuilder.new, &block).build
        end
        
        def self.part(&block)
            Docile.dsl_eval(PartBuilder.new, &block).build
        end
    
        def self.clip(&block)
            Docile.dsl_eval(ClipBuilder.new, &block).build
        end
    
        def self.event(&block)
            Docile.dsl_eval(EventBuilder.new, &block).build
        end
    
        def self.transition(&block)
            Docile.dsl_eval(TransitionBuilder.new, &block).build
        end

        def self.get_binding
            return binding
        end
    end

    #
    # Builders
    # -----------------------------------------------------------------
    class PieceBuilder
        def initialize
            @piece = Piece.new
        end

        def title(v) @piece.title = v; self; end
        def tempo(v) @piece.tempo = v.to_i; self; end
        def repetitions(v) @piece.repetitions = v.to_i; self; end
        def seed(v) @piece.seed = v.to_i; self; end

        def part(&block)
            @piece.parts << ConfigReader.part(&block)
            self
        end

        def build
            @piece
        end
    end

    class PartBuilder
        def initialize
            @part = Part.new
        end

        def name(v) @part.name = v; self; end

        def clip(&block)
            c = ConfigReader.clip(&block)
            @part.clips[c.label] = c
            self
        end

        def transition(&block)
            @part.transitions << ConfigReader.transition(&block)
            self
        end

        def build 
            @part 
        end
    end

    class ClipBuilder
        def initialize
            @clip = Clip.new
        end

        def label(v)
            @clip.label = v.to_sym
            self
        end

        def event(&block)
            @clip.events << ConfigReader.event(&block)
            self
        end

        def build 
            @clip 
        end
    end

    class EventBuilder
        def initialize
            @event = Event.new
        end

        def note(v) @event.note = v.to_sym; self; end
        def dynamic(v) @event.dynamic = v.to_sym; self; end
        def duration(v) @event.duration = v.to_sym; self; end

        def build 
            @event 
        end
    end

    class TransitionBuilder
        def initialize
            @transition = Transition.new
        end

        def from(v) @transition.from = v.to_sym; self; end
        def to(v) @transition.to = v.to_sym; self; end
        def probability(v) @transition.probability = v.to_f; self; end

        def build 
            @transition 
        end
    end

    #
    # DSL components
    # -----------------------------------------------------------------
    class Piece
        attr_accessor :title, :tempo, :repetitions, :seed, :parts

        def initialize
            @title = 'untitled'
            @tempo = 90 # beats per minute
            @repetitions = 0 # there will be this many clips in the output
            @seed = nil # or a random number seed
            @parts = []
        end

        def valid?
            errors.empty?
        end

        def errors
            error_list = []

            # have basics
            error_list << "Untitled piece" if @title.nil? || @title.length == 0
            error_list << "#{@title}: invalid tempo #{@tempo}" unless @tempo > 0
            error_list << "#{@title}: no parts" if @parts.empty?
            error_list << "#{@title}: seed should be a number" unless @seed.nil? || (@seed.is_a? Integer)


            # part errors
            error_list += @parts.map { |p| p.errors }.flatten

            error_list
        end
    end

    class Part
        attr_accessor :name, :clips, :transitions

        def initialize()
            @name = 'untitled'
            @clips = {}
            @transitions = []
        end

        def valid?
            errors.empty?
        end

        def errors
            error_list = []

            # empty part is useless
            error_list << "#{@name}: empty part" if @clips.empty? && @transitions.empty?

            # transitions from x -> * sum to 1
            tx = @transitions.reduce({}) do |store, transition|
                store[transition.from] = 0 unless store.include? transition.from
                store[transition.from] = store[transition.from] + transition.probability
                store
            end
            tx.select { |k,v| v < 0.9999}.each { |k,v| error_list << "#{@name}: transitions for #{k} sum to #{v}"}

            # clips are all used
            froms = Set.new @transitions.map {|t| t.from }
            tos = Set.new @transitions.map {|t| t.to }
            clip_keys = Set.new @clips.keys
            unused_clips = (clip_keys - froms) - tos
            unused_clips.each { |c| error_list << "#{@name}: unused clip #{c}" }
            (froms - clip_keys).each  { |c| error_list << "#{@name}: transition 'from' without clip: #{c}" }
            (tos - clip_keys).each  { |c| error_list << "#{@name}: transition 'to' without clip: #{c}" }

            error_list
        end
    end

    class Clip
        attr_accessor :label, :events

        def initialize
            @label = nil
            @events = []
        end
    end
    
    class Event
        attr_accessor :note, :dynamic, :duration

        def initialize
            @note = :a1
            @dynamic = :mf
            @duration = :quaver
        end
    end

    class Transition
        attr_accessor :from, :to, :probability
    end
end