#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint native_file_preview.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'native_file_preview'
  s.version          = '1.0.1'
  s.summary          = 'A Flutter plugin that provides native file preview functionality for iOS and Android platforms.'
  s.description      = <<-DESC
Native file preview plugin for Flutter. Displays files (PDF, images, documents, and more) using the platform's native preview controllers — QLPreviewController on iOS and the system viewer on Android — so previews look and behave exactly like the OS-level experience.
                       DESC
  s.homepage         = 'https://github.com/johnny-bytes/native_file_preview'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Johnny Bytes GmbH' => 'info@johnnybytes.com' }
  s.source           = { :path => '.' }
  s.source_files = 'native_file_preview/Sources/native_file_preview/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'native_file_preview_privacy' => ['native_file_preview/Sources/native_file_preview/PrivacyInfo.xcprivacy']}
end
