
Pod::Spec.new do |s|
  s.name         = 'OnOffButton'
  s.version      = '1.1'
  s.summary      = 'Custom On/Off UIButton'

  s.description  = <<-DESC
                   Custom On/Off Animated UIButton, written in Swift. By Creativedash
                   DESC

  s.homepage     = 'https://github.com/rakaramos/OnOffButton'

  s.license      ='MIT'

  s.author             = { 'Rafael Machado' => 'raka.cdc@gmail.com' }
  s.social_media_url   = 'http://twitter.com/rakaramos'

  s.ios.deployment_target = '8.1'
  s.requires_arc = true

  s.source       = { :git => 'https://github.com/rakaramos/OnOffButton.git', :tag => s.version }
  s.source_files  = 'Sources/*.swift'

 end
