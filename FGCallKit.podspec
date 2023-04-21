#
# Be sure to run `pod lib lint FGCallKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FGCallKit'
  s.version          = '1.1.0'
  s.summary          = '飞鸽传书语音通话SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/huangchangweng/FGCallKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huangchangweng' => '599139419@qq.com' }
  s.source           = { :git => 'https://github.com/huangchangweng/FGCallKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'FGCallKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FGCallKit' => ['FGCallKit/Assets/*.png']
  # }
  
  s.subspec 'Gossip' do |ss|
    ss.source_files = 'FGCallKit/Classes/Gossip/*'
    ss.dependency 'xpjsip'
  end
  
  s.subspec 'JJBNetworking' do |ss|
    ss.source_files = 'FGCallKit/Classes/JJBNetworking/*'
  end
  
  # 在HEADER_SEARCH_PATHS中添加"$(PODS_ROOT)/Headers/Public/xpjsip/include"
  s.pod_target_xcconfig = {"HEADER_SEARCH_PATHS" => '"$(PODS_ROOT)/Headers/Public/xpjsip/include"'}

  s.static_framework = true

  s.public_header_files = ['FGCallKit/Classes/FGCallKit.h', 'FGCallKit/Classes/FGCall.h']
  
  # 依赖系统库
  s.frameworks = "AVFoundation", "CoreData", "WebKit", "SystemConfiguration", "MobileCoreServices", "AudioToolbox"
  s.libraries = 'stdc++', 'c++', 'z'
 
#  s.dependency 'pjsip', '2.9.0.2'
#  s.dependency 'xpjsip'
  s.dependency 'MJExtension'
#  s.dependency 'VialerSIPLib', '3.7.3'
#  s.dependency 'AFNetworking', '~>4.0.1'
end
