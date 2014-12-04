Pod::Spec.new do |s|
  s.name             = "SimpleKeychain"
  s.version          = "0.2.1"
  s.summary          = "A wrapper to make it really easy to deal with iOS Keychain and store your user's credentials securely."
  s.description      = <<-DESC
                       A simple way to store items in iOS Keychain, without the hassle of dealing with iOS Keychain API directly.
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
end
