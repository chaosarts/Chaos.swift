#
# Be sure to run `pod lib lint INITCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChaosKit'
  s.version          = '1.0.0'
  s.summary          = 'Framework network specific issues'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Framework network specific issues
                       DESC

  s.homepage         = 'https://github.com/chaosarts/Chaos'
  s.license          = { :type => 'Apache License', :file => 'LICENSE' }
  s.author           = { 'Fu Lam Diep' => 'fulam.diep@chaosarts.de' }
  s.source           = { 
    :git => 'https://github.com/chaosarts/Chaos.git', 
    :tag => 'Kit-' + s.version.to_s 
  }

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = '6.0'

  s.source_files = 'ChaosKit/Classes/**/*'
  s.swift_version = '5.1'
  
  s.dependency 'ChaosCore', '~> 1.0.0'
  s.dependency 'ChaosUi', '~> 1.0.0'
  s.dependency 'ChaosNet', '~> 1.0.0'
end
