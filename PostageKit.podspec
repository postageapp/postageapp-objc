Pod::Spec.new do |s|
  s.name     = 'PostageKit'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A Mac OSX / iOS API wrapper for the PostageApp transactional mail service'
  s.homepage = 'https://github.com/postageapp/postageapp-objc'
  s.authors  = { 'Stephan Leroux' => 'stephanleroux@gmail.com' }
  s.source   = { :git => 'https://github.com/postageapp/postageapp-objc.git', :tag => '1.0.0' }
  s.source_files = 'PostageKit'
  s.requires_arc = true
  s.dependency 'AFNetworking', '>= 1.1.0'

  s.ios.deployment_target = '5.0'
  s.ios.frameworks = 'MobileCoreServices', 'SystemConfiguration'

  s.osx.deployment_target = '10.7'
  s.osx.frameworks = 'CoreServices', 'SystemConfiguration'

  s.prefix_header_contents = <<-EOS
#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <MobileCoreServices/MobileCoreServices.h>
#else
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <CoreServices/CoreServices.h>
#endif
EOS
end