# Here goes your database connection and options:

# Here go your requires for models:
# require 'model/user'

require('dm-core')
require('dm-aggregates')
require('dm-serializer')
require('dm-validations')
require('dm-transactions')
require('dm-types')

# Here go your requires for model classes:
#controllers folder
model_folder = WDE.current_dir('model')

#controllers to load
model_files = ['base',
               'user',
               'category',
               'content',
               'comment',
               'post']

###load files###
model_files.each() do |md_file|
    require(model_folder + md_file)
end
###

#database setup
app_db_dsn = 'mysql://wish:wish@localhost/wishdreamevents?encoding=UTF-8'
if (WDE.current_environment() == :development)
    app_db_dsn = 'mysql://localhost/wishdreamevents?encoding=UTF-8'
    DataMapper::Logger.new(STDOUT, :debug)
end

DataMapper.setup(:default, app_db_dsn)