#!/usr/bin/ruby

require 'xcodeproj'

#modifies every open source dependency project file
#the intention of this script is to reduce open source libs noise
#and optionally and eventually fine tune their settings if needed

folder = "#{File.dirname(__FILE__)}/Carthage/Checkouts"
xcode_project_file_paths = Dir.glob("#{folder}/**/*.xcodeproj")

xcode_project_file_paths.each do |project_path|
    project = Xcodeproj::Project.open(project_path)
    puts File.basename(project_path, ".xcodeproj") + " configured."
    project.build_configurations.each do |config|
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS']  ||= 'YES'
        config.build_settings['RUN_CLANG_STATIC_ANALYZER'] ||= 'NO'
    end
    project.save
end
