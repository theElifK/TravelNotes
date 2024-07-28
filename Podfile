# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TravelNotes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  
  pod 'ObjectMapper'
  pod 'IBAnimatable'
  pod 'DropDown'
  pod 'Charts'
  pod 'FirebaseCore'
  pod 'FirebaseAuth'
  pod 'FirebaseStorage'
  pod 'FirebaseFirestore'
  pod 'SDWebImage'
  pod 'SwiftKeychainWrapper'
  pod 'FittedSheets'
  # Pods for TravelNotes
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # some older pods don't support some architectures, anything over iOS 11 resolves that
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0’
      end
    end
  end
end
