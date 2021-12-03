Pod::Spec.new do |s|
  s.name             = 'ChaosSwiftUI'
  s.version          = '1.0.0'
  s.summary          = 'Collection of all Chaos iOS Frameworks'
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

  s.ios.deployment_target     = '14.0'
  s.osx.deployment_target     = '11.0'
  s.watchos.deployment_target = '6.0'

  s.source_files  = 'ChaosSwiftUI/Classes/**/*'
  s.frameworks    = 'Foundation'
  s.dependency 'ChaosCore'
  s.dependency 'ChaosMath'
  s.dependency 'ChaosGraphics'
end
