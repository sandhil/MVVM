platform :ios, '13.0'

use_frameworks!

target 'MVVM' do
  pod 'RxAlamofire'
  pod 'AlamofireNetworkActivityLogger'
  pod 'RxSwift'
  pod 'SwiftDate', '~> 6.0.3'
  pod 'Swinject'
  pod 'KeychainAccess'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
end
