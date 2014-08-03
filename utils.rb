# Utility functions to drive some parts of midilib more easily

require 'pp'

require 'midilib/event'
include MIDI

module HAP

  # ----------------------------------------------------------------------
  # Key signatures: defined by the number of flats (-7 to -1), C or A (0),
  # or sharps (+1 to +7) and whether the key is major or minor.
  KEYS = []
  majors = [:Cb, :Gb, :Db, :Ab, :Eb, :Bb, :F, :C, :G, :D, :A, :E, :B, :Fs, :Cs]
  MAJOR_KEY = majors.length.times.inject(Hash.new) do |h, i|
    KEYS << majors[i]
    h[majors[i]] = KeySig.new(i-7, false)
    h
  end
  minors = majors[3..-1] + [:Gs, :Ds, :As]
  MINOR_KEY = KEYS.length.times.inject(Hash.new) do |h, i|
    KEYS << minors[i]
    h[minors[i]] = KeySig.new(i-7, true)
    h
  end
  KEYS.uniq!
  
  # gets the major key event for :K
  def self.major(k) 
    return MAJOR_KEY[k]
  end
  
  # gets the minor key event for :K
  def self.minor(k)
    return MINOR_KEY[k]
  end
  # ----------------------------------------------------------------------

  # Define the notes of the octave starting at middle C.
  NOTES = { :C=>60, 
    :Cs=>61, :Db=>61,
    :D=>62,
    :Ds=>62, :Eb=>63,
    :E=>64,
    :F=>65,
    :Fs=>66, :Gb=>66,
    :G=>67,
    :Gs=>68, :Ab=>68,
    :A=>69,
    :As=>70, :Bb=>70,
    :B=>71, :Cb=>71,
    :C2=>72}

  # ----------------------------------------------------------------------

  # Play a Markov sequence to a track, each note having the same
  # given duration, with the given number of repetitions.
  def play_sequence(mk, first, duration, repeats, track, channel=0)
    n = first
    repeats.times do |i|
      to_enumerable(n).each do |u|
        n = u
        track.events << NoteOn.new(channel, NOTES[n], 127, 0)
        track.events << NoteOff.new(channel, NOTES[n], 127, duration)
      end
      n = mk.next_node(n)
    end
  end

  def to_enumerable(x)
    return x if x.is_a? Enumerable
    return [x]
  end


end # HAP
