require 'midilib/sequence'
require 'midilib/consts'

require_relative 'config'
require_relative 'markov/chain'

module Hap

  class Hap
    @config = nil

    def initialize
    end

    def load(src)
      # data = File.open(src).read
      # @config = eval(data, ConfigReader.get_binding)
    end

    def convert_to_midi(dest)
      # seq = MIDI::Sequence.new()

      # # Create a first track for the sequence. This holds tempo events and stuff
      # # like that.
      # track = MIDI::Track.new(seq)
      # seq.tracks << track
      # track.events << MIDI::Tempo.new(Tempo.bpm_to_mpq(120))
      # track.events << MIDI::MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

      # # Create a track to hold the notes. Add it to the sequence.
      # track = MIDI::Track.new(seq)
      # seq.tracks << track

      # # Give the track a name and an instrument name (optional).
      # track.name = 'My New Track'
      # #track.instrument = GM_PATCH_NAMES[0]

      # # Add a volume controller event (optional).
      # track.events << MIDI::Controller.new(0, CC_VOLUME, 127)

      # # Add events to the track: a major scale. Arguments for note on and note off
      # # constructors are channel, note, velocity, and delta_time. Channel numbers
      # # start at zero. We use the new Sequence#note_to_delta method to get the
      # # delta time length of a single quarter note.
      # track.events << MIDI::ProgramChange.new(0, 1, 0)
      # quarter_note_length = seq.note_to_delta('quarter')
      # [0, 2, 4, 5, 7, 9, 11, 12].each do |offset|
      #   track.events << MIDI::NoteOn.new(0, 64 + offset, 127, 0)
      #   track.events << MIDI::NoteOff.new(0, 64 + offset, 127, quarter_note_length)
      # end

      # # Calling recalc_times is not necessary, because that only sets the events'
      # # start times, which are not written out to the MIDI file. The delta times are
      # # what get written out.

      # track.recalc_times

      # File.open('from_scratch.mid', 'wb') { |file| seq.write(file) }
    end

  end
end