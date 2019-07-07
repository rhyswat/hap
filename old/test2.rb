require 'midilib/sequence'
require 'midilib/consts'
include MIDI

require_relative 'markov'
require_relative 'utils'
include HAP

# The MIDI sequence
seq = Sequence.new()

# Create a first track for the sequence.
track = Track.new(seq)
seq.tracks << track
track.events << Tempo.new(Tempo.bpm_to_mpq(120))
track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

# Create a track to hold the notes. Add it to the sequence.
lower = Track.new(seq)
upper = Track.new(seq)
seq.tracks << lower
seq.tracks << upper


# play a tune....
# -- CHAIN C>D>E>C mostly
mk = Markov.new(34565)
mk.assign(:C, [:E, :D, :E]=>0.9, :E=>0.1)
mk.assign(:D, :E=>0.9, :C=>0.1)
mk.assign(:E, :C=>0.85, :D=>0.15)
play_sequence mk, :C, seq.note_to_delta('16th'), 16*100, lower 

mk = Markov.new(34565)
mk.assign(:C2, [:A, :G]=>0.9, :C2=>0.1)
mk.assign(:G, :A=>0.3, :C2=>0.7)
mk.assign(:A, :G=>0.8, :C2=>0.2)
play_sequence mk, :C2, seq.note_to_delta('16th'), 16*100, upper


File.open('test2.mid', 'wb') { |f| seq.write(f) }
puts 'Done :)'
