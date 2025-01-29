#
# Be sure to run `pod lib lint APHTTPMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APHTTPMonitor'
  s.version          = '1.0.0'
  s.summary          = 'An useful monitor for all the HTTP traffic of your app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  APHTTPMonitor is a simple HTTP monitoring tool. You just need to add a line of code in your app and navigate to a specific URL on another terminal’s browser. You’ll see a simple and clear webpage with a listing of HTTP requests and the corresponding responses.
                       DESC

  s.homepage         = 'https://github.com/apellegrino91/APHTTPMonitor.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '14331895' => 'antongiuliopellegrino@gmail.com' }
  s.source           = { :git => 'https://github.com/apellegrino91/APHTTPMonitor.git' }, :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'APHTTPMonitor/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'Swifter', '1.5.0'
  s.resource_bundles = {
    'APHTTPMonitor' => ['APHTTPMonitor/Assets/**/*']
  }
end
