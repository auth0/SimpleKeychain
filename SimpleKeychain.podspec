Pod::Spec.new do |s|
  s.name             = "SimpleKeychain"
  s.version          = "0.1.0"
  s.summary          = "A simple way to store items in iOS Keychain"
  s.description      = <<-DESC
                       A simple way to store items in iOS Keychain, without the hassle of dealing with iOS API directly.
                       It has support for the new AccessControl for Keychain items added in iOS 8.
                       DESC
  s.homepage         = "https://github.com/auth0/SimpleKeychain"
  s.license          = 'MIT'
  s.author           = { "Hernan Zalazar" => "hernan@auth0.com" }
  s.source           = { :git => "https://github.com/auth0/SimpleKeychain.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/authzero'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'A0Keychain' => ['Pod/Assets/*.png']
  }
end
