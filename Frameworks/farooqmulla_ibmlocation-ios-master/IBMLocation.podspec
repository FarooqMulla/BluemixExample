Pod::Spec.new do |s|

  s.name         	 = "IBMLocation"
  s.version      	 = "1.0.1.20150720-1718"
  s.summary          = "Use the iOS SDK to develop applications for the Apple iPhone or iPad that use the Mobile Cloud Services."
  s.homepage         = "https://hub.jazz.net/project/bluemixmobilesdk/ibmlocation-ios/overview"
  s.description      = <<-DESC
                       The Mobile Cloud Services SDK for iOS integrates with 
                       the IBM Bluemix Mobile Cloud Services. The SDK has a modular design, 
                       so you can add add services that are required by your 
                       application as needed.   
                       DESC

  s.license          = 'IBM'
  s.author           = { "IBM Bluemix Mobile Cloud SDK" => "mobilsdk@us.ibm.com" }
  s.social_media_url = 'https://twitter.com/IBMBlueMix'

  s.platform     	 = :ios, '6.1'
  # s.ios.deployment_target = '7.0'
  s.requires_arc 	 = false

  s.source           = { 
                          :git => "https://hub.jazz.net/git/bluemixmobilesdk/ibmlocation-ios.git", 
                          :tag => s.version.to_s,
                          :submodules => false
                       }

  s.source_files 	 = "IBMLocation.framework/Versions/A/**/*.h"
  s.preserve_paths 	 = 'IBMLocation.framework'
  s.frameworks 		 = 'IBMLocation'
  s.xcconfig 		 = {'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/IBMLocation"'}
  
  s.dependency			'IBMBluemix',  '~> 1.0.0'
  s.dependency			'IBMData',     '~> 1.0.0'
  s.dependency			'IBMFileSync', '~> 1.0.0'
  
end