#
# Be sure to run `pod lib lint EZJUserDataCollectorLibIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EZJUserDataCollectorLibIOS"
  s.version          = "0.3.4"
  s.summary          = "collector for users' data and save them"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
collector for users' data and save them
                       DESC

  s.homepage         = "http://zhangjing@123.57.37.167:8089/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "ingridzhang" => "zhangjing@ezjie.cn" }
  s.source           = { :git => "http://123.57.37.167:8089/r/EZJUserDataCollectorLibIOS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'EZJUserDataCollectorLibIOS' => ['Pod/Assets/*.png']
  }

    s.public_header_files = 'Pod/Classes/**/*.h'
    s.library = "z"
  # s.frameworks = 'UIKit', 'MapKit'
  # s.vendored_frameworks = "EZJUserDataCollectorLibIOS/**/*.{framework}"
    s.dependency 'EZFramework'
    s.dependency 'FMDB', '~> 2.5'
    s.dependency 'EZJCrashCollectorIOS', '~> 1.1.0'
end
