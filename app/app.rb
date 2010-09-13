require('sinatra/base')
require('rack-flash')
require('rack-datamapper-session')
require('htmlentities')
require('rexml/parsers/pullparser')
require('erubis')
require('i18n')
require('sanitize')
require('singleton')
require('yaml')

module WDE
    class App
        include(Singleton)
        
        #constructor
        def initialize()
        end
        
        #init app
        def init(env=:development)
            #environment
            @_env = env
            if (!@_env.instance_of?(Symbol))
                @_env = @_env.to_sym()
            end
            
            #current_dir
            @_cur_dir = self._current_dir()
            
            #read config file
            @_config = YAML.load_file("#{ @_cur_dir }etc/#{ @_env.to_s() }.yaml")
            
            #init I18n
            self.load_I18n()
            
            return self
        end
        
        def current_dir()
            return @_cur_dir
        end
        
        def env()
            return @_env
        end
        
        def config()
            return @_config.clone()
        end
        
        def load_I18n(args={})
            if (args && args.has_key?('reload') && args['reload'])
                I18n.reload!()
            else
                #set i18n backend
                I18n.backend = I18n::Backend::Simple.new()
                
                #load translation files
                i18n_dir = self.current_dir() + 'i18n/'
                I18n.load_path = Dir.glob("#{ i18n_dir }*.yml")
            end
            
            return true
        end
        
        protected
        
            def _current_dir()
                path = File.dirname(__FILE__) + "/"
                
                return path
            end
    end
    
    def self.init_app(env)
        return App.instance().init(env)
    end
    
    def self.app()
        return App.instance()
    end
end

#init app
WDE.init_app(:development)

#require libs
require("#{ WDE.app().current_dir() }lib/common")
require("#{ WDE.app().current_dir() }lib/user_auth")

# Initialize controllers and models
require("#{ WDE.app().current_dir() }model/init")
require("#{ WDE.app().current_dir() }controller/init")