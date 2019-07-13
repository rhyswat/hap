Gem::Specification.new do |s|
  s.name         = 'hap'
  s.version      = '0.0.1'
  s.platform     = Gem::Platform::RUBY
  s.summary      = 'Creu cerddoriaeth MIDI drwy hap.'
  s.description  = 'Creu cerddoriaeth MIDI drwy hap :: Creating MIDI music files by random processes'

  s.authors      = ['Rhys Watkin']
  s.email        = 'rhyswat@gmail.com'
  s.homepage     = 'https://github.com/rhyswat/hap'
  s.license      = 'MIT'
  
  s.files        = Dir.glob('{bin,lib,spec}/**/*') + ['README.md']
  s.executables  = ['hap']
  s.bindir       = 'bin'
  s.require_path = 'lib'
  
end
