module WDE
    module Controllers
        module Admin
            class Main < BaseAdmin
                before() do
                    @menu_selected = nil
                end
                
                #admin dashboard
                get('/?') do
                    self.redirect('/admin/blog/')
                    #return self.erubis(:dashboard)
                end
                
                #login
                get_or_post('/login/?') do
                    message = nil
                    login = nil
                    
                    if (self.request.request_method().match(/post/i) &&
                        self.request.params['_submit'])
                        login = self.request.params['login']
                        
                        #check user credentials
                        begin
                           @user.authenticate(self.request.params['login'],
                                              self.request.params['password'])
                           
                           #redirect to dashboard
                           self.redirect('/admin/')
                        rescue Exception => ex
                            message = "Invalid User or Password"
                        end
                    end
                    
                    return self.erubis(:login,
                                       :layout => false,
                                       :locals => {:message => message,
                                                   :login   => login
                                                   })
                end
                
                #logout
                get('/logout/?') do
                    if (@user.authenticated?())
                        #destroy session data
                        self.request.session.clear()
                        @user = nil
                        
                        #force to generate a new session
                        self.request.env['rack.session.options'][:renew] = true
                    end
                    
                    #redirect to login page
                    self.redirect('/admin/login/')
                end
            end #end class definition
        end
    end
end