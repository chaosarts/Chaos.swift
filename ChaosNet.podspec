Pod::Spec.new do |s|
  s.name             = 'ChaosNet'
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

  s.ios.deployment_target     = '12.0'
  s.osx.deployment_target     = '10.13'
  s.watchos.deployment_target = '6.0'

  s.source_files  = 'ChaosNet/Classes/**/*'
  s.frameworks    = 'Foundation'
  s.dependency 'ChaosCore'
  s.dependency 'Hippolyte', '~> 1.2.0', :configurations => :debug
end
