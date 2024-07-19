Pod::Spec.new do |s|

  s.name         = 'SystemFontOverride'
  s.version      = '1.0.0'
  s.summary      = 'Easy font branding for your iOS app.'
  s.homepage     = 'https://github.com/yonat/SystemFontOverride'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }

  s.author       = { 'Yonat Sharon' => 'yonat@ootips.org' }

  s.platform     = :ios, '14.0'
  s.swift_versions = ['5.0']

  s.source       = { :git => 'https://github.com/yonat/SystemFontOverride.git', :tag => s.version }
  s.source_files  = 'Sources/SystemFontOverride/*.swift'
  s.resource_bundles = {s.name => ['Sources/SystemFontOverride/PrivacyInfo.xcprivacy']}

end
