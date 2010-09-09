module WDE
    module Model
        class Category < Base
            include DataMapper::Resource
            storage_names[:default] = 'tb_categories' #database table name
            
            #associations
            has(1, :parent, :model => 'Category', :child_key => [:parent_id])
            has(n, :category_contents, :model => 'CategoryContent', :child_key => [:category_id])
            has(n, :contents, :through => :category_contents)
            
            #properties
            property(:id, Serial)
            property(:parent_id, Integer)
            property(:title, String, :length => (1 .. 255))
            property(:name, String, :writer => :protected)
            property(:path, String, :writer => :protected)
            
            ###validations###
            #TODO: check if path already exists
            
            before(:save) do
                if (self.parent)
                    self.parent_id = self.parent().id
                end
                
                #set name
                self.name = self._generate_name()
                
                #set path
                self.path = self._generate_path()
            end
            
            protected
            
                def _generate_path()
                    build_path = ""
                    
                    if (self.parent)
                        build_path += self.parent.path
                    else
                        build_path += "/"
                    end
                    
                    build_path += self.name + "/"
                    
                    return build_path
                end
                
                def _generate_name()
                    final_name = nil
                    
                    #check if name was provided
                    if (self.attribute_dirty?(:name))
                        final_name = self.name
                    else
                        #use title
                        final_name = self.title
                    end
                    
                    #sanitize and return (remove accents)
                    return final_name.sanitize()
                end
        end #end class
        
        class CategoryContent
            include DataMapper::Resource
            storage_names[:default] = 'tb_categories_contents' #database table name
            
            #associations
            belongs_to(:category, :model => 'Category', :child_key => [:category_id])
            belongs_to(:content, :model => 'Content', :child_key => [:content_id])
            
            #properties
            property(:category_id, Integer, :key => true)
            property(:content_id, Integer, :key => true)
            property(:weight, Integer, :default => 10)
        end
        
    end
end
