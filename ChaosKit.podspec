Pod::Spec.new do |s|
  s.name             = 'ChaosKit'
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

  s.source_files  = 'ChaosKit/Classes/**/*'
  s.frameworks    = 'Foundation'
  s.dependency 'ChaosCore'
  s.dependency 'ChaosNet'
  s.dependency 'ChaosUi'
end
