# default task
task :default => :spec

desc 'Run the test specs'
task :spec do
    fail unless system "rspec -fd"
end
task :test => :spec

desc 'Build the gem'
task :build do
    system "gem build hap.gemspec"
end

desc 'Install the gem locally'
task :install => [:spec, :build] do
    system "gem uninstall --force --all --executables hap"
    system "gem install hap"
end

