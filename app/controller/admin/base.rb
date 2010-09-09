module WDE
    module Controllers
        module Admin
            class BaseAdmin < Controller
                #before action filter, (executed on all requests)
                before() do
                    if (self.request.env['REQUEST_URI'].match(/^\/admin\/login\/?$/))
                        if (@user.authenticated?())
                            #logoff user
                            self.redirect('/admin/logout/')
                        end
                    elsif (!@user.authenticated?())
                        self.redirect('/admin/login/')
                    end
                end
                
                def erubis(template, options={})
                    if (!options.has_key?(:layout))
                        options[:layout] = "admin/layout".to_sym()
                    end
                    
                    #if not absolute path, inside admin
                    if (template[0] != '/')
                        template = "admin/#{ template.to_s() }"
                    else
                        #template = template[1 .. -1]
                    end
                    
                    return super(template.to_sym(), options)
                end
            end #end class definition
        end
    end
end