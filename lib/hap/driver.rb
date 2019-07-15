require_relative 'config'
require_relative 'symbols'
require_relative '../markov/chain'

require 'midilib/sequence'
require 'midilib/consts'

module Hap
    class Driver
        @markov_chain = nil
        @config = nil

        @default_dynamic = :mf
        @default_duration = ''
    
        def initialize
        end
    
        def load(src)
          data = File.open(src).read
          @config = eval(data, ConfigReader.get_binding)
          @markov_chain = Markov::Chain.new @config.seed
        end
    
        def convert_to_midi(dest)
            # create a new sequence
            seq = MIDI::Sequence.new()

            # metadata track
            track = MIDI::Track.new(seq)
            seq.tracks << track
            track.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(@config.tempo))
            track.events << MIDI::MetaEvent.new(MIDI::META_SEQ_NAME, @config.title)

            # each part gets a track
            @config.parts.each_with_index do |part, channel|
                # build the transition table
                build_transitions part

                # Create a track to hold the notes. Add it to the sequence.
                track = MIDI::Track.new(seq)
                track.name = part.name
                seq.tracks << track

                track.events << MIDI::ProgramChange.new(channel, 1, 0)

                # keep adding clips until the time is filled
                clip_label = nil
                this_repetition = 0
                while this_repetition < part.repetitions do
                    this_repetition += 1
                    clip_label, clip = next_clip(clip_label, part)
                    clip.events.each do |event|
                        # note symbol => midi value
                        note_value = NOTES[event.note]

                        # dynamics / volume => midi velocity
                        v = event.dynamic || :mp
                        velocity = DYNAMICS[v]

                        crotchet_length = seq.note_to_delta('quarter')
                        d = event.duration || :crotchet
                        duration = crotchet_length * DURATIONS[d]

                        track.events << MIDI::NoteOn.new(0, note_value, velocity, 0)
                        track.events << MIDI::NoteOff.new(0, note_value, velocity, duration.to_i)
                    end
                    track.recalc_times
                end
            end
    
            File.open(dest, 'wb') { |file| seq.write(file) }
        end

        def build_transitions(part)
            @markov_chain.clear!

            mappings = part.transitions.reduce({}) do |m, tx|
                m[tx.from] = {} if m[tx.from].nil?
                m[tx.from][tx.to] = tx.probability
                m
            end

            mappings.each { |from, weights| @markov_chain.assign(from, weights) }
        end

        # Gets [next clip label, next clip] given the current clip label
        def next_clip(current_clip_label, part)
            return part.clips.first if current_clip_label.nil?

            next_label = @markov_chain.next_node current_clip_label
            return next_label, part.clips[next_label]
        end
    
    end
end