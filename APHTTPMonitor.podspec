#
# Be sure to run `pod lib lint APHTTPMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APHTTPMonitor'
  s.version          = '0.9.0'
  s.summary          = 'An useful monitor for all the HTTP traffic of your app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/apellegrino91/APHTTPMonitor.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '14331895' => 'antongiuliopellegrino@gmail.com' }
  s.source           = { :git => 'https://github.com/apellegrino91/APHTTPMonitor.git' }#, :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'APHTTPMonitor/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'Swifter', '1.5.0'
  s.resource_bundles = {
    'APHTTPMonitor' => ['APHTTPMonitor/Assets/**/*']
  }
end
