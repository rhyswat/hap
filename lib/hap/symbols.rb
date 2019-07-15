module Hap

    def self.octave(octave_number)
        # notes of the scale, omitting E-sharp / F-flat
        note_names = [%w[c], %w[cs db], %w[d], %w[ds eb], %w[e], %w[f], %w[fs gb], %w[g], %w[gs ab], %w[a], %w[as bb], %w[b]].freeze

        # octave 4 starts at middle C with midi value 60
        low_octave = octave_number < 4
        octave_start = 12 * (octave_number + 1)

        # key = note name a-g
        #       then optional b or s for flat or sharp
        #       then underscore, 
        #       then octave number
        # around middle C we have :as_3/:bb_3, :b_3, :c_4, :cs_4/:db_4, :d_4, ...
        mapping = {}
        note_names.each_with_index do |enharmonic_group, index|
            enharmonic_group.each do |n|
                midi_value = octave_start + index
                next if midi_value < 21 || midi_value > 108 # off the ends of a piano
                s = "#{n}_#{octave_number}".to_sym
                mapping[s] = midi_value
            end
        end
        mapping
    end

    NOTES = (0..8).reduce({}) { |final, n | final.merge self.octave(n) }.freeze

    # Fixed mapping of music dynamics to midi velocities
    DYNAMICS = {
        :pp => 20,
        :p => 40,
        :mp => 60,
        :mf => 80,
        :f => 100,
        :ff => 120
    }.freeze

    # Fixed mappings of note values to multiples of a crotchet at current bpm
    DURATIONS = {
        :semibreve => 4.0,
        :minim => 2.0,
        :crotchet => 1.0,
        :quaver => 0.5,
        :semiquaver => 0.25
        # etc
    }
end