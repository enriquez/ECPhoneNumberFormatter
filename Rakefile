desc "Build bundles"
task :build => :clean do
  gcc = RbConfig::CONFIG['CC']
  cflags = RbConfig::CONFIG['CFLAGS'] + ' ' + RbConfig::CONFIG['ARCH_FLAG']
  cflags.sub!(/-O./, '-O3')
  cflags << " -Wall"

  Dir.chdir('ext/PhoneNumberFormatter') do
    sh "#{gcc} #{cflags} -fobjc-gc PhoneNumberFormatter.m -c -o PhoneNumberFormatter.o"
    sh "#{RbConfig::CONFIG['LDSHARED']} -lcrypto PhoneNumberFormatter.o -o PhoneNumberFormatter.bundle"
  end
end

desc "Clean packages and extensions"
task :clean do
  sh "rm -rf ext/PhoneNumberFormatter/*.o ext/PhoneNumberFormatter/*.bundle"
end

desc "Run specs"
task :default => :build do
  sh "macbacon spec/*_spec.rb"
end

