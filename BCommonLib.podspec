Pod::Spec.new do |s|
  s.name         = "BCommonLib"
  s.version      = "0.6"
  s.summary      = "for baboy use."
  s.homepage     = "http://github.com/baboy/BCommonLib"
  s.author       = { "baboy" => "baboyzyh@gmail.com" }
  s.source       = { :git => "https://github.com/baboy/BCommonLib.git", :tag => "0.6" }
  s.platform     = :ios

  s.source_files = 'BCommonLib/Classes/*.{h,m}'


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
	mod.subspec 'sliding menu' do |sld|
		sld.source_files = 'BCommonLib/Classes/modules/sliding menu'
	end
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
