require('sinatra/base')
require('rack-flash')
require('rack-datamapper-session')
require('htmlentities')
require('rexml/parsers/pullparser')
require('erubis')
require('i18n')
require('sanitize')

module WDE
    def self.current_dir(folder = nil)
        path = File.dirname(__FILE__) + "/"
        if (folder != nil)
            path += folder + "/"
        end
        
        return path
    end
    
    def self.current_environment()
        return :production
    end
    
    def self.load_I18n(args={})
        if (args && args.has_key?('reload') && args['reload'])
            I18n.reload!()
        else
            #set i18n backend
            I18n.backend = I18n::Backend::Simple.new()
            
            #load translation files
            i18n_dir = self.current_dir('i18n')
            I18n.load_path = Dir.glob("#{ i18n_dir }*.yml")
        end
        
        return true
    end
end

#get current dir
cur_dir = WDE.current_dir()

#require libs
require("#{ cur_dir }lib/common")
require("#{ cur_dir }lib/user_auth")

# Initialize controllers and models
require("#{ cur_dir }model/init")
require("#{ cur_dir }controller/init")

#init I18n
WDE.load_I18n()