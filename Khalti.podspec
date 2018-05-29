#
# Be sure to run `pod lib lint Khalti.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Khalti'
  s.version          = '1.0.5'
  s.summary          = 'Khalti is the new generation Payment Gateway, Digital Wallet and API provider for various services.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    Khalti is the new generation Payment Gateway, Digital Wallet and API provider for various services. We provide you with true Payment Gateway, where you can accepts payments from: Khalti User, Net Banking customers of our partner banks (need not be Khalti user).
                       DESC

  s.homepage         = 'https://github.com/khalti/khalti-sdk-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'khalti' => 'info@khalti.com' }
  s.source           = { :git => 'https://github.com/khalti/khalti-sdk-ios.git', :branch => 'master', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'khalti/Classes/**/*.{swift}'
  
  s.resource_bundles = {
    'Khalti' => ['khalti/Assets/**/*.{png,storyboard,xib,xcassets}']
  }

  # s.public_header_files = 'khalti/Classes/**/*.h'
  s.frameworks = 'UIKit'
#  s.dependency 'Alamofire'
end
