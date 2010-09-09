class UserAuth
    #factory method to get current user object
    def self.get(request)
        user = nil
        
        #if (request.session.has_key?(:user))
        if (request.session[:user])
            user = request.session[:user]
        else
            #create new userauth
            user = UserAuth.new()
            request.session[:user] = user
        end
        
        return user
    end
    
    #instance public attributes
    attr_accessor(:data)
    
    #constructor
    def initialize()
        @_username = nil
        @data = Hash.new()
    end
    
    #return bool, check's if user is authenticated
    def authenticated?()
        if (@_username)
            return true
        end
        
        return false
    end
    
    #authenticate the user
    def authenticate(username, password)
        #check on database
        user = WDE::Model::User.all(:login => username).first()
        if (!user)
            raise(Exception, "invalid user")
        end
        
        if (user.password.downcase() != password)
            raise(Exception, "invalid password")
        end
        
        @_username = username
    end
    
    #logout user
    #def logout()
    #    @_username = nil
    #    @data = Hash.new()
    #end
    
    #return the user roles
    def roles()
        if (!self.authenticated?())
            return ['guest']
        end
        
        #get the roles from the db and return them
        return []
    end
    
    def username()
        return @_username
    end
end