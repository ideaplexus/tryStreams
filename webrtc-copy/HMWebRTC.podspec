#
# Be sure to run `pod lib lint HMWebRTC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMWebRTC'
  s.version          = '0.2.0'
  s.summary          = 'A wrapper of Google WebRTC on iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tdhman/HMWebRTC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TRAN DIEP Hue Man' => 'htp1@3ds.com' }
  s.source           = { :git => 'https://github.com/tdhman/HMWebRTC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'HMWebRTC/Classes/**/*.{h,m}', 'Lib/**/*'
  s.resources = 'HMWebRTC/Classes/VideoChatUI/*.{xib,xcassets,json,imageset,png}'
  s.resource_bundles = {
      'HMWebRTC' => ['HMWebRTC/Classes/**/*.{storyboard,xib,xcassets,json,imageset,png}']
  }
  s.requires_arc = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.library = 'icucore'
  s.frameworks = 'UIKit', 'CoreGraphics'
  s.dependency 'GoogleWebRTC'
end
