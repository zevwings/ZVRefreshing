#
#  Be sure to run `pod spec lint ZVRefreshing.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZVRefreshing"
  s.version      = "2.1.1"
  s.summary      = "A pure-swift and wieldy refresh component."
  s.swift_version = '4.2'
  
  s.description  = <<-DESC
  					ZRefreshing is a pure-swift and wieldy refresh component.
                   DESC

  s.homepage     = "https://github.com/zevwings/ZVRefreshing"
  s.license 	 = 'MIT'
  s.author       = { "zevwings" => "zev.wings@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zevwings/ZVRefreshing.git", :tag => "#{s.version}" }
  s.resources    = "ZVRefreshing/Resource/*"
  s.requires_arc = true

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
  	core.source_files = "ZVRefreshing/**/*.swift", "ZVRefreshing/ZVRefreshing.h"
    core.dependency "ZVActivityIndicatorView"
  end

  s.subspec 'RxSwift' do |rx|
  	rx.source_files  = "ZVRefreshing+Rx/**/*.swift", "ZVRefreshing+Rx/ZVRefreshing-Rx.h"
  	rx.dependency "ZVRefreshing/Core"
  	rx.dependency "RxSwift"
  	rx.dependency "RxCocoa"
  end

end
