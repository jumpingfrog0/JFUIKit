#
# Be sure to run `pod lib lint JFUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JFUIKit'
  s.version          = '0.1.0'
  s.summary          = 'Cocoa Touch UIKit framework categories.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Cocoa Touch UIKit framework categories wrote in Objective-C.
                       DESC

  s.homepage         = 'https://github.com/jumpingfrog0/JFUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jumpingfrog0' => 'jumpingfrog0@gmail.com' }
  s.source           = { :git => 'https://github.com/jumpingfrog0/JFUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/Classes/**/*'
  
  s.resource_bundles = {
  	'JFUIKit' => ['Source/Assets/*.png']
  }

  s.public_header_files = 'Source/Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'JFFoundation', '~> 0.1.0'
end
