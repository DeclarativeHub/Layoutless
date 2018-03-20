Pod::Spec.new do |s|
  s.name             = "Layoutless"
  s.version          = "0.1.3"
  s.summary          = "Write less UI code"
  s.description      = "Layoutless enables you to spend less time writing UI code. It provides a way to abstract common layout patterns and enable consistent styling approach."
  s.homepage         = "https://github.com/DeclarativeHub/Layoutless"
  s.license          = 'MIT'
  s.author           = { "Srdan Rasic" => "srdan.rasic@gmail.com" }
  s.source           = { :git => "https://github.com/DeclarativeHub/Layoutless.git", :tag => "0.1.3" }

  s.ios.deployment_target       = '9.3'
  s.tvos.deployment_target      = '11.0'

  s.source_files      = 'Sources/**/*.swift', 'Layoutless/**/*.{h,m}'
  s.requires_arc      = true
  s.swift_version     = '4.0'
end
