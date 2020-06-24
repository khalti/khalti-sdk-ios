#
# Be sure to run `pod lib lint Khalti.podspec' to ensure this is a
# valid spec before submitting.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Khalti'
  s.version          = '1.0.15'
  s.summary          = 'Khalti is the new generation Payment Gateway, Digital Wallet and API provider for various services.'
  s.description      = <<-DESC
    Khalti is the new generation Payment Gateway, Digital Wallet and API provider for various services. We provide you with true Payment Gateway, where you can accepts payments from: Khalti User, Net Banking customers of our partner banks (need not be Khalti user).
                       DESC
  s.homepage         = 'https://khalti.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'khalti' => 'info@khalti.com' }
  s.source           = { :git => 'https://github.com/khalti/khalti-sdk-ios.git', :branch => 'master', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/KhaltiOfficial'
  s.ios.deployment_target = '8.0'
  s.source_files = 'khalti/Classes/**/*.{swift}'
  s.resource_bundles = {
    'Khalti' => ['khalti/Assets/**/*.{png,storyboard,xib,xcassets}']
  }
  s.frameworks = 'UIKit'
end
