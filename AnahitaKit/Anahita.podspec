Pod::Spec.new do |s|
  s.name     = 'Anahita'
  s.version  = '0.0.1'
  s.license  = 'Apache License, Version 2.0'
  s.summary  = 'An iOS framework whose growth is bounded by O(documentation).'
  s.homepage = ''
  s.author   = { 'Arash Sanieyan'    => 'ash@anahitapolis.com'}
  s.source   = { :git => '/Users/asanieyan/Projects/AnahitaKit' , :commit => 'HEAD' }
  s.description = 'Anahita.'
  s.platform = :ios, '5.0'
  s.requires_arc = true
    
  s.subspec 'Foundation' do |subspec|    
    subspec.header_dir   = 'Foundation'
    subspec.source_files = 'src/Foundation'    
  end
  
  s.subspec 'UIKit' do |subspec|    
    subspec.header_dir   = 'UIKit'
    subspec.source_files = 'src/UIKit'
	subspec.dependency 'JRSwizzle'
  end  
  
  s.subspec 'CoreGraphics' do |subspec|    
  	subspec.header_dir   = 'CoreGraphics'
    subspec.source_files = 'src/CoreGraphics'
  end
  
  s.subspec 'CoreSupport' do |subspec|    
  	subspec.header_dir   = 'CoreSupport'  
    subspec.source_files = 'src/CoreSupport'  
    subspec.dependency 'Anahita/Foundation'
	subspec.dependency 'Anahita/CoreGraphics'
	subspec.dependency 'Anahita/UIKit' 
	subspec.dependency 'Nimbus/Core'	 
  end

  s.subspec 'AnahitaUI' do |subspec|
  	subspec.header_dir   = 'AnahitaUI'  
    subspec.source_files = 'src/AnahitaUI'
    subspec.dependency 'Anahita/AnahitaAPI'
    subspec.dependency 'Anahita/CommonUI'   
    subspec.dependency 'Anahita/Validation' 
  end
    
  s.subspec 'AnahitaAPI' do |subspec|
  	subspec.header_dir   = 'AnahitaAPI'  
    subspec.source_files = 'src/AnahitaAPI'
    subspec.dependency 'Anahita/RestKit'
  end
    
  s.subspec 'RestKit' do |subspec|
  	subspec.header_dir   = 'RestKit'  
    subspec.source_files = 'src/RestKit'
    subspec.dependency 'Anahita/CoreSupport'
	subspec.dependency 'RestKit/Core', '0.20.3'
  end
  
  s.subspec 'MapKit' do |subspec|
  	subspec.header_dir   = 'MapKit'  
    subspec.source_files = 'src/MapKit'
    subspec.dependency 'Anahita/CoreSupport'
    subspec.frameworks = ['MapKit']
  end  
  
  s.subspec 'CoreLocation' do |subspec|
  	subspec.header_dir   = 'CoreLocation'  
    subspec.source_files = 'src/CoreLocation'
    subspec.dependency 'Anahita/CoreSupport'
    subspec.frameworks = ['CoreLocation']
  end  
  
  s.subspec 'Styler' do |subspec|    
  	subspec.header_dir   = 'Styler'
   	subspec.source_files = 'src/Styler'  
  end

  s.subspec 'CommonUI' do |subspec|
    subspec.header_dir   = 'CommonUI'  
    subspec.source_files = 'src/CommonUI'
    subspec.dependency 'Anahita/AnahitaAPI'
    subspec.dependency 'Anahita/Styler'    
    subspec.dependency 'Nimbus/Models'    
    subspec.dependency 'Nimbus/WebController'
    subspec.dependency 'JASidePanels'
  end  
  
  s.subspec 'Validation' do |subspec|
    subspec.header_dir   = 'Validation'  
    subspec.source_files = 'src/Validation'    
  end  
  
  s.subspec 'Validation' do |subspec|
    subspec.header_dir   = 'Validation'  
    subspec.source_files = 'src/Validation'    
  end  

end