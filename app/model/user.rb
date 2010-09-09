module WDE
    module Model
        class User < Base
            include DataMapper::Resource
            storage_names[:default] = 'tb_users' #database table name
            
            #properties
            property(:id, Serial)
            property(:name, String)
            property(:login, String, :unique => true)
            property(:password, String)
            property(:email, String, :unique => true)
        end
    end
end