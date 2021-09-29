require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-spotim"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-spotim
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-spotim"
  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }
  s.authors      = { "Itay Dressler" => "itay.d@openweb.com" }
  s.platforms    = { :ios => "10.3" }
  s.source       = { :git => "https://github.com/github_account/react-native-spotim.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "SpotIMCore", '1.6.2'

end
