Pod::Spec.new do |s|
  s.name = "FGCallKit"
  s.version = "0.9.7"
  s.summary = "\u98DE\u9E3D\u4F20\u4E66\u8BED\u97F3\u901A\u8BDDSDK"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"huangchangweng"=>"599139419@qq.com"}
  s.homepage = "https://github.com/huangchangweng/FGCallKit"
  s.description = "TODO: Add long description of the pod here."
  s.frameworks = ["Foundation", "UIKit"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '10.0'
  s.ios.vendored_framework   = 'ios/FGCallKit.framework'
end
