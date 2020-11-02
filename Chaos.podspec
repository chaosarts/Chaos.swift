#
# Be sure to run `pod lib lint INIT.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  ios_deployment_target = '12.0'

  s.name             = 'Chaos'
  s.version          = '1.0.0'
  s.summary          = 'Collection of all Chaos iOS Frameworks'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Collection of all Chaos iOS Frameworks. Blablbalba
                       DESC

  s.homepage         = 'https://github.com/chaosarts/Chaos'
  s.license          = { :type => 'Apache License', :file => 'LICENSE' }
  s.author           = { 'Fu Lam Diep' => 'fulam.diep@chaosarts.de' }
  s.source           = {
      :git => 'https://github.com/chaosarts/Chaos.git',
      :tag => s.version.to_s
  }

  s.ios.deployment_target     = ios_deployment_target
  s.osx.deployment_target     = '10.13'
  s.watchos.deployment_target = '6.0'

  s.info_plist = {
    'CFBundleIdentifier' => 'de.chaosarts'
  }

  s.subspec 'Core' do |subspec|
    subspec.source_files  = 'ChaosCore/Classes/**/*'
    subspec.frameworks    = 'Foundation'
    subspec.dependency 'PromisesSwift', '~> 1.2.8'
  end

  s.subspec 'Net' do |subspec|
    subspec.source_files  = 'ChaosNet/Classes/**/*'
    subspec.frameworks    = 'Foundation'
    subspec.dependency 'Chaos/Core'
  end

  s.subspec 'Ui' do |subspec|
    subspec.source_files  = 'ChaosUi/Classes/**/*'
    subspec.frameworks    = 'Foundation'
    subspec.dependency 'Chaos/Core'
  end
  
  s.subspec 'Kit' do |subspec|
    subspec.source_files  = 'ChaosKit/Classes/**/*'
    subspec.frameworks    = 'Foundation'
    subspec.dependency 'Chaos/Core' 
    subspec.dependency 'Chaos/Net'
    subspec.dependency 'Chaos/Ui'
  end
end
