Pod::Spec.new do |s|
  s.name         = "RMUniversalAlert"
  s.version      = "0.1"
  s.summary      = "Wrapper for UIAlertController / UIAlertView / UIActionSheet for targeting all iOS versions"
  s.homepage     = "https://github.com/ryanmaxwell/RMUniversalAlert"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = "Ryan Maxwell"
  s.source       = { :git => "https://github.com/ryanmaxwell/RMUniversalAlert", :tag => '0.1' }
  s.source_files  = 'RMUniversalAlert.{h,m}'
  s.requires_arc = true
  s.platform = 'ios'
  s.dependency 'UIAlertView+Blocks'
  s.dependency 'UIActionSheet+Blocks'
end
