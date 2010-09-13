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
            set(:root, WDE.app().current_dir())
            set(:static, true)
            set(:environment, WDE.app().env())
            #set(:raise_errors, false)
            set(:show_exceptions, false)
            
            #before action filter, (executed on all requests)
            before() do
                self._classify_post_data_as_utf8(self.request.params)
                
                @user = UserAuth.get(self.request)
                if (self.request.params.has_key?('l'))
                    @user.data[:locale] = self.request.params['l'].to_sym()
                elsif (!@user.data.has_key?(:locale))
                    @user.data[:locale] = :pt #default language
                end
                
                @title = "wish.dreamevents"
            end
            
            def self.get_or_post(path, options={}, &block)
                get(path, options, &block)
                post(path, options, &block)
            end
            
            error() do
                "something went wrong, please try again later..."
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
                
                #I18n translation
                def t(str, opts={})
                    opts[:locale] = @user.data[:locale]
                    return I18n.t(str, opts)
                end
                
                #I18n localization
                def l(dt, opts={})
                    opts[:locale] = @user.data[:locale]
                    return I18n.localize(dt, opts)
                end
        end
    end
end

# Here go your requires for subclasses of Controller:
#controllers folder
ctrl_folder = WDE.app().current_dir() + 'controller/'

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
