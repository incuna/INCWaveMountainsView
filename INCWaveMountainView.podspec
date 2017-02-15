#
#  Be sure to run `pod spec lint INCWaveMountainView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "INCWaveMountainView"
  s.version      = "0.0.1"
  s.summary      = "This view creates an animation set up by a percent"
  s.homepage     = "https://www.incuna.com/en/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Carlos Pages" => "carlos@incuna.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/incuna/incuna-incwavemountainsview-ios.git", :tag => "0.0.1" }

  s.source_files  = "Pod/Classes/*.*"

end
