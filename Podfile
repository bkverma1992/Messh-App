# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Mesh App' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

pod 'SDWebImage'
pod 'IQKeyboardManagerSwift'
pod 'CropViewController'
pod 'Firebase/Core'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Messaging'
pod 'Firebase/DynamicLinks'
pod 'SwiftMessageBar'
pod 'MessageKit'
pod 'ImageSlideshow', '1.5.3'
pod 'ImageSlideshow/Alamofire', '1.5.3'
pod 'SwiftLinkPreview', '~> 3.0.0'
pod 'JGProgressHUD'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        
        if ['SwiftLinkPreview'].include?(target.name)
            config.build_settings['SWIFT_VERSION'] = '4.2'
            else
            config.build_settings['SWIFT_VERSION'] = '3.0'
         end
     end
  end
end

 
