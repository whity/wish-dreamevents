# Define a subclass of Sinatra::Base holding your defaults for all
# controllers
require('helper/app_wide')
require('helper/widgets')
require('helper/sinatra_partials')

module WDE
    module Controllers
        class Controller < Sinatra::Base
            helpers(WDE::Helpers)
            helpers(WDE::Helpers::Widgets)
            helpers(Sinatra::Partials)
            
            #controller config
            set(:root, WDE.current_dir())
            set(:static, true)
            set(:environment, WDE.current_environment())
            
            #before action filter, (executed on all requests)
            before() do
                #TODO: initialize i18n object
                self._init_I18n()
                
                self._classify_post_data_as_utf8(self.request.params)
                
                @user = UserAuth.get(self.request)
                @title = "wish.dreamevents"
            end
            
            def self.get_or_post(path, options={}, &block)
                get(path, options, &block)
                post(path, options, &block)
            end
            
            protected
            
                def _classify_post_data_as_utf8(data)
                    #ensure all posted data is in utf8, recursive method
                    
                    if (data.kind_of?(Hash))
                        data.each() do |key, value|
                            data[key] = self._classify_post_data_as_utf8(value)
                        end
                    elsif (data.kind_of?(Array))
                        data.each_index() do |idx|
                            data[idx] = self._classify_post_data_as_utf8(data[idx])
                        end
                    else
                        data.force_encoding('UTF-8')
                    end
                    
                    return data
                end
                
                def _init_I18n()
                    I18n.backend = I18n::Backend::Simple.new()
                    I18n.default_locale = 'pt'
                    #I18n.load_path = [WDE.current_dir + 'i18n/pt.yml']
                    I18n.backend.load_translations(WDE.current_dir + 'i18n/pt.yml')
                end
        end
    end
end

# Here go your requires for subclasses of Controller:
#controllers folder
ctrl_folder = WDE.current_dir('controller')

#controllers to load
ctrl_files = ['main',
              'blog',
              'admin/base',
              'admin/main',
              'admin/blog']

#load files
ctrl_files.each() do |md_file|
    require(ctrl_folder + md_file)
end
##
