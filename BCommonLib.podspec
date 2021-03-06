#
#  Be sure to run `pod spec lint BCommonLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BCommonLib"
  s.version      = "0.25"
  s.summary      = "for baboy use."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    nothing.
                   DESC

  s.homepage     = "https://github.com/baboy/BCommonLib"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "BSD"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "baboy" => "baboyzyh@gmail.com" }
  # Or just: s.author    = "baboy"
  # s.authors            = { "baboy" => "baboyzyh@gmail.com" }
  # s.social_media_url   = "http://twitter.com/baboy"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "7.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/baboy/BCommonLib.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files = 'BCommonLib/Classes/*.{h,m}'
  #s.source_files  = "BCommonLib/Classes", "BCommonLib/Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'app' do |app|    
    app.resource = 'BCommonLib/Classes/app/default.api.plist', 'BCommonLib/Classes/app/default.conf.plist'
    app.source_files = 'BCommonLib/Classes/app'
  end
  s.subspec 'modules' do |mod|
    mod.source_files = 'BCommonLib/Classes/modules'
    mod.subspec 'AFNetworking' do |af|
      af.source_files = 'BCommonLib/Classes/modules/AFNetworking'
    end
    mod.subspec 'share' do |share|
      share.source_files = 'BCommonLib/Classes/modules/share'
    end
    #mod.subspec 'sliding menu' do |sld|
      #sld.source_files = 'BCommonLib/Classes/modules/sliding menu'
    #end
    mod.subspec 'tracker' do |tracker|
      tracker.source_files = 'BCommonLib/Classes/modules/tracker'
    end
  end
  s.subspec 'model' do |model|
    model.source_files = 'BCommonLib/Classes/model'
    model.subspec 'member' do |member|
      member.source_files = 'BCommonLib/Classes/model/member'
    end
    model.subspec 'app' do |app|
      app.source_files = 'BCommonLib/Classes/model/app'
    end
  end
  s.subspec 'common' do |common|     
    common.subspec 'categories' do |cate|
      cate.source_files = 'BCommonLib/Classes/common/categories'
    end 
    common.subspec 'dao' do |dao|
    dao.resource = 'BCommonLib/Classes/common/dao/db.plist'
      dao.source_files = 'BCommonLib/Classes/common/dao'
    end 
    common.subspec 'controller' do |controller|
      controller.source_files = 'BCommonLib/Classes/common/controller'
    end 
    common.subspec 'ext' do |ext|
      ext.source_files = 'BCommonLib/Classes/common/ext'
    end
    common.subspec 'map' do |map|
      map.source_files = 'BCommonLib/Classes/common/map'
    end
    common.subspec 'network' do |network|
      network.source_files = 'BCommonLib/Classes/common/network'
    end
    common.subspec 'ui' do |ui|
      ui.source_files = 'BCommonLib/Classes/common/ui'
    end
    common.subspec 'utils' do |utils|
      utils.source_files = 'BCommonLib/Classes/common/utils'
    end
    common.subspec 'theme' do |theme|
      theme.resource = 'BCommonLib/Classes/common/theme/default.string.plist', 'BCommonLib/Classes/common/theme/default.theme.plist'
      theme.source_files = 'BCommonLib/Classes/common/theme'
    end
    common.subspec 'web' do |web|
      web.source_files = 'BCommonLib/Classes/common/web'
    end
  end

  s.frameworks = 'UIKit', 'QuartzCore', 'CFNetwork', 'AVFoundation', 'CoreFoundation', 'CoreGraphics', 'Security', 'AudioToolbox', 'MediaPlayer', 'MobileCoreServices', 'SystemConfiguration', 'CoreMedia', 'Mapkit', 'CoreLocation', 'MessageUI', 'ImageIO'

  s.libraries   = 'sqlite3.0', 'xml2', 'icucore', 'z'

end
