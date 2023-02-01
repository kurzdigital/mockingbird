#
# Be sure to run `pod lib lint Mockingbird.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Mockingbird-Networking'
  s.version          = '0.6.2'
  s.summary          = 'A custom URLProtocol to mock networking responses'

  s.description      = <<-DESC
  Use Mockingbird to easily mock your sever requests during UITesting.
                       DESC

  s.homepage         = 'https://github.com/kurzdigital/mockingbird'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Braun' => 'christian.braun@theempathicdev.de' }
  s.source           = { :git => 'https://github.com/kurzdigital/mockingbird.git', :tag => s.version.to_s }

  s.osx.deployment_target = "10.13"
  s.ios.deployment_target = "13.0"
  s.swift_version = "5.0"

  s.source_files = 'Mockingbird/Classes/**/*'
end
