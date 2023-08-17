Pod::Spec.new do |spec|

  spec.name               = "W-NablaMessagingCore"
  spec.version            = "2.0.0"
  spec.summary            = "FORKED: NablaMessagingCore iOS SDK"

  spec.description        = <<-DESC
      The Nabla iOS SDK makes it quick and easy to build an excellent healthcare communication experience in your iOS app. 
      We provide powerful and customizable UI elements that can be used out-of-the-box to create a full healthcare communication experience. 
      We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

      Right now the library is in alpha, meaning all core features are here and ready to be used but API might change during the journey to a stable 1.0 version.
  DESC

  spec.homepage           = "https://www.nabla.com"
  spec.documentation_url  = "https://docs.nabla.com"
  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.author             = "Nabla Technologies"
  spec.platform           = :ios, "13.0"
  spec.swift_versions     = '5.0'
  spec.source             = { :git => "https://github.com/wawafertility/rn-nabla-ios.git", :tag => "#{spec.version}" }
  spec.source_files       = ["Sources/NablaMessagingCore/**/*.swift"]
  spec.resource_bundles   = {"NablaMessagingCoreResources" => "Sources/NablaMessagingCore/Resources/**/*"}

  spec.dependency           'W-NablaCore', "#{spec.version}"
end
