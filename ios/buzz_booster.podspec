#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint buzz_booster.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'buzz_booster'
  s.version          = '4.22.0'
  s.summary          = 'BuzzBooster SDK'
  s.description      = 'BuzzBooster Flutter Plugin Project'
  s.homepage         = 'https//buzzvil.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Buzzvil' => 'damon.gong@buzzvil.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = 'Assets/**/*'
  s.dependency 'Flutter'
  s.dependency 'BuzzBoosterSDK', '4.22.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
