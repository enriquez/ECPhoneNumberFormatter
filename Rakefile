desc "Run tests"
task :test do
  system 'xctool -workspace Tests/ECPhoneNumberFormatter/ECPhoneNumberFormatter.xcworkspace -scheme ECPhoneNumberFormatter -sdk iphonesimulator test'
end

namespace :travis do
  task :before_install do
    system 'brew update'
  end

  task :install do
    system 'brew uninstall xctool'
    system 'brew install xctool --HEAD'
    system '(cd Tests/ECPhoneNumberFormatter/ && pod install)'
  end

  task :script => 'test'
end
