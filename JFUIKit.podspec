#
# Be sure to run `pod lib lint JFUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JFUIKit'
  s.version          = '0.2.1'
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

  s.resource_bundles = {
  	'JFUIKit' => ['Source/Assets/*.png']
  }

  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'JFFoundation', '~> 0.2.0'
  s.default_subspecs = 'UIApplication', 'UIBarButtonItem', 'UIButton', 'UIColor', 'UIDevice', 'UIImage', 'UILabel',
  	'UINavigationBar', 'UINavigationController', 'UINavigationItem', 'UIScrollView', 'UITextField', 'UIView', 'UIViewController'

  s.source_files = 'Source/Classes/JFUIKit.h'
  s.public_header_files = 'Source/Classes/JFUIKit.h'

  s.subspec 'UIApplication' do |ss|
  	ss.source_files = 'Source/Classes/UIApplication/*.{h,m}'
  end

  s.subspec 'UIBarButtonItem' do |ss|
  	ss.source_files = 'Source/Classes/UIBarButtonItem/*.{h,m}'
	ss.dependency 'JFUIKit/UIImage'
	ss.dependency 'JFUIKit/UINavigationBar'
  end
	
  s.subspec 'UIButton' do |ss|
  	ss.source_files = 'Source/Classes/UIButton/*.{h,m}'
  end

  s.subspec 'UIColor' do |ss|
  	ss.source_files = 'Source/Classes/UIColor/*.{h,m}'
  end

  s.subspec 'UIDevice' do |ss|
  	ss.source_files = 'Source/Classes/UIDevice/*.{h,m}'
  end

  s.subspec 'UIImage' do |ss|
  	ss.source_files = 'Source/Classes/UIImage/*.{h,m}', 'Source/Classes/NSBundle/*.{h,m}'
	ss.public_header_files = 'Source/Classes/UIImage/*.{h}'
	ss.private_header_files = 'Source/Classes/NSBundle/*.{h}'
  end

  s.subspec 'UILabel' do |ss|
  	ss.source_files = 'Source/Classes/UILabel/*.{h,m}'
  end

  s.subspec 'UINavigationBar' do |ss|
  	ss.source_files = 'Source/Classes/UINavigationBar/*.{h,m}'
	ss.dependency 'JFUIKit/UIImage'
  end

  s.subspec 'UINavigationController' do |ss|
  	ss.source_files = 'Source/Classes/UINavigationController/*.{h,m}'
  end

  s.subspec 'UINavigationItem' do |ss|
  	ss.source_files = 'Source/Classes/UINavigationItem/*.{h,m}'
	ss.dependency 'JFUIKit/UIView' 
	ss.dependency 'JFUIKit/UINavigationBar'
  end

  s.subspec 'UIScrollView' do |ss|
  	ss.source_files = 'Source/Classes/UIScrollView/*.{h,m}'
  end

  s.subspec 'UITextField' do |ss|
  	ss.source_files = 'Source/Classes/UITextField/*.{h,m}'
  end
  
  s.subspec 'UIView' do |ss|
  	ss.source_files = 'Source/Classes/UIView/*.{h,m}'
	ss.dependency 'JFUIKit/UIDevice' 
 	ss.dependency 'JFUIKit/UIColor'
 	ss.dependency 'JFUIKit/UIImage'
	ss.dependency 'JFUIKit/UIApplication'
  end

  s.subspec 'UIViewController' do |ss|
  	ss.source_files = 'Source/Classes/UIViewController/*.{h,m}'
  end

  s.subspec 'Hook' do |ss|
	#ss.source_files = 'Source/Classes/Hook/**/*.{h,m}'
	ss.subspec 'SwipeBack' do |sp|
      sp.source_files = 'Source/Classes/Hook/SwipeBack/*.{h,m}'
	end

	ss.subspec 'UITabBar' do |sp|
      sp.source_files = 'Source/Classes/Hook/UITabBar/*.{h,m}'
	end
  end

end

