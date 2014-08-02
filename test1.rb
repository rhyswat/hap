require_relative 'markov'
require_relative 'sonic_stub'

# MIDI notes
MIDI = {:c=>60, :d=>62, :e=>64, :g=>67, :a=>69, :c2=>72}
NOTES = MIDI.length

# markov probability chain
mk = Markov.new(34565)
# C > D or E
mk.assign(:c, :d=>0.4, :e=>0.6)
# D > any but D equally
mk.any(:d, MIDI.keys - [:d])
# E > A always
mk.assign(:e, :a=>1)
# G > any but G equally
mk.any(:g, MIDI.keys - [:g])
# A > C' or G
mk.assign(:a, :c2=>0.2, :g=>0.8)
# C' > C
mk.assign(:c2, :c=>1.0)

# Compose something...
tune = []
p = :c
20.times do |j|
  tune << p
  play MIDI[p]
  sleep 0.2
  p = mk.next_node(p)
end
puts tune.inspect
puts "Done"

  
  
