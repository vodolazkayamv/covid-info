# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'covid-info' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for covid-info
	pod 'Google-Mobile-Ads-SDK'
  target 'covid-infoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'covid-infoUITests' do
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.3'
    end
  end
end
