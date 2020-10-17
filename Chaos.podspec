#
# Be sure to run `pod lib lint INIT.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Chaos'
  s.version          = '1.0.0'
  s.summary          = 'Collection of all Chaos iOS Frameworks'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A collection of all pods by chaosarts
                       DESC

  s.homepage         = 'https://github.com/chaosarts/Chaos'
  s.license          = { :type => 'Apache License', :file => 'LICENSE' }
  s.author           = { 'Fu Lam Diep' => 'fulam.diep@chaosarts.de' }
  s.source           = {
      :git => 'https://github.com/chaosarts/Chaos.git',
      :tag => s.version.to_s
  }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = '6.0'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |subspec|
      subspec.dependency 'ChaosCore'
  end

#  s.subspec 'Net' do |subspec|
#      subspec.dependency 'ChaosNet'
#  end
#
#  s.subspec 'NetStub' do |subspec|
#      subspec.dependency 'ChaosNetStub'
#  end
#
#  s.subspec 'Ui' do |subspec|
#      subspec.dependency 'ChaosUi'
#  end
end
