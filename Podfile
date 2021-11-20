# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Koinex' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Koinex
    pod 'Firebase/Analytics'
    pod 'Firebase/Auth'
    pod 'Firebase/Core'
    pod 'Firebase/Storage'
    pod 'Firebase/Firestore'
    pod 'FirebaseFirestoreSwift'
    pod 'Alamofire'
    pod 'SVProgressHUD'

  target 'KoinexTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'KoinexUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

end
