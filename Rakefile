desc "Run tests"
task :test do
  exit_status = system 'xctool -workspace Tests/ECPhoneNumberFormatter/ECPhoneNumberFormatter.xcworkspace -scheme ECPhoneNumberFormatter -sdk iphonesimulator test'
  exit(exit_status)
end

namespace :travis do
  task :before_install do
    system 'brew update'
  end

  task :install do
    system 'brew uninstall xctool'
    system 'brew install xctool --HEAD'
  end

  task :script => 'test'
end
