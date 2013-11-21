desc "Run tests"
task :test do
  system 'xcodebuild -workspace Tests/ECPhoneNumberFormatter/ECPhoneNumberFormatter.xcworkspace -scheme ECPhoneNumberFormatter test -sdk iphonesimulator'
end

namespace :travis do
  task :script => 'test'
end
