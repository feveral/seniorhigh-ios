# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'seniorhigh' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for seniorhigh
  pod 'SQLite.swift', '~> 0.12.0'
  pod 'Google-Mobile-Ads-SDK'
  pod 'MaterialComponents/Tabs'
  pod 'SnapKit', '~> 5.0.0'

  target 'seniorhighTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'seniorhighUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
