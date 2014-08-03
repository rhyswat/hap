# Cerddoriaeth ar hap

Cerddoriaeth ar hap drwy Sonic Pi (a phethau eraill)

## Seiliau
Cyffredinol:
* Ruby 1.9+
* Sonic Pi, http://www.cl.cam.ac.uk/projects/raspberrypi/sonicpi/
* Ruby midilib drwy `$ gem install midilib`
 neu https://github.com/jimm/midilib
 neu https://github.com/rhyswat/midilib

Ar y Pi:
* timididy, lame, mpg123 drwy `$ apt-get install timidity lame mpg123`

## Cyfansoddi
Dyma'r camau:

1. Creu ffeil gerddoriaethe ar-hap e.e. `test1.rb`
2. Ei allforio drwy `$ ./deploy_spi markov.rb <ac eraill> <ac yn ola test1.rb>`
3. *I'w sgwennu - creu ffeil MIDI o'r allbwn*
4. Allforio o MIDI i MP3 drwy `$ timidity -Ow -o - input.mid | lame - output.mp3`
   
   Tybied mai O-am-Owen yw'r ddau opsiwn, nid 0-am-ddim.
   
   (Diolch i https://www.kirsle.net/blog/entry/convert-midi-music-to-mp3)
