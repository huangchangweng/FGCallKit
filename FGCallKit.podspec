#
# Be sure to run `pod lib lint FGCallKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FGCallKit'
  s.version          = '0.8.5'
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
  end
  
  s.static_framework = true

  s.public_header_files = ['FGCallKit/Classes/FGCallKit.h', 'FGCallKit/Classes/FGCall.h']
 
  s.dependency 'AFNetworking', '4.0.1'
#  s.dependency 'pjsip', '2.9.0.2'
  s.dependency 'xpjsip', '2.12.1'
  s.dependency 'MJExtension', '3.4.1'
#  s.dependency 'VialerSIPLib', '3.7.3'
end
