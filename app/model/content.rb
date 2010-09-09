module WDE
    module Model
        #class contents base
        class Content < Base
            include DataMapper::Resource
            storage_names[:default] = 'tb_contents' #database table name
            
            def self.available_status(enum=false)
                if (enum)
                    return Enum[:created, :draft, :published, :deleted]
                end
                
                return [nil, :draft, :published, :deleted]
            end
            
            #associations
            has(n, :content_values, :model => 'ContentValue', :child_key => [:content_id])
            has(n, :comments, :model => 'Comment', :child_key => [:content_id])
            has(n, :status_history, :model => 'ContentStatusHistory', :child_key => [:content_id])
            belongs_to(:content_type, :model => 'ContentType', :child_key => [:type_name])
            has(n, :content_categories, :model => 'CategoryContent', :child_key => [:content_id])
            has(n, :categories, :through => :content_categories)
            
            #properties
            property(:id, Serial)
            property(:title, String)
            property(:type_name, Discriminator)
            property(:status, self.available_status(true))
            property(:updated_by, String)
            property(:updated, String, :writer => :protected)
            property(:status_by, String, :writer => :protected)
            property(:status_dt, String, :writer => :protected)
            
            #validations
            validates_presence_of(:title, :message => 'Title is required')
            
            #methods
            before(:save) do
                cur_datetime = Time.now()
                self.updated = cur_datetime.strftime("%Y-%m-%d %H:%M:%S")
                
                #check if status was changed
                if (self.attribute_dirty?(:status))
                    if (self.new?() && self.status != :created)
                        #create 'created' status history
                        self.status_history().new(:by        => self.updated_by,
                                                  :date_time => self.updated,
                                                  :status    => :created
                                                  )
                    elsif (!self.new?())
                        #get original values of status
                        original_status = nil
                        self.original_attributes.each() do |orig_key, orig_value|
                            if (orig_key.name == :status)
                                original_status = orig_value
                            end
                        end
                        
                        self.status_history().new(:by        => self.status_by, #still has the prev status_by
                                                  :date_time => self.status_dt,
                                                  :status    => original_status
                                                  )
                    end
                    
                    self.status_by = self.updated_by
                    self.status_dt = self.updated
                end
            end
            
            def save(*args)
                #exec_code = Proc.new() do
                exec_code = lambda() do
                    #validates item
                    #if (!self.valid?())
                    #    next false
                    #end
                    
                    #update/remove dynamic fields (content_values)
                    force_update = false
                    dyn_cols = self.content_values.length - 1
                    dyn_cols.downto(0) do |idx|
                        item = self.content_values[idx]
                        
                        if (item.value == nil)
                            if (!item.new?())
                                force_update = true
                            end
                            
                            self.content_values.delete_at(idx)
                            item.destroy()
                        elsif (item.dirty?())
                            force_update = true
                        end
                    end
                    
                    if (force_update)
                        #set updated_time to nil to force update in parent object
                        self.updated = nil
                    end
                    #########
                    
                    if (!super(*args)) #execute parent save
                        return false
                    end
                    
                    return true
                end
                
                save_result = false
                cur_trans = self.repository.adapter.current_transaction()
                if (!cur_trans)
                    Content.transaction() do |trans|
                        save_result = exec_code.call()
                        if (!save_result)
                            trans.rollback()
                        end
                    end
                else
                    save_result = exec_code.call()
                end
                
                return save_result
            end
            
            protected
                
                def self.custom_fields_accessors(fields_name)
                    fields_name.each() do |field|
                        self.class_eval(%Q{
                            def #{ field.to_sym() }()
                                return self._get_dyn_field("#{ field }")
                            end
                            
                            def #{ field.to_sym() }=(new_value)
                                return self._set_dyn_field("#{ field }", new_value)
                            end
                        })
                    end
                end
                
                def _set_dyn_field(field, new_value)
                    found = nil
                    
                    self.content_values.each() do |item|
                        if (item.name == field)
                            found = item
                            found.value = new_value
                            break
                        end
                    end
                    
                    if (!found)
                        found = self.content_values.new(:name => field, :value => new_value)
                    end
                    
                    return new_value
                end
                
                def _get_dyn_field(field)
                    self.content_values.each() do |item|
                        if (item.name == field)
                            return item.value
                        end
                    end
                    
                    return nil
                end
        end
        
        class ContentStatusHistory
            include DataMapper::Resource
            storage_names[:default] = 'tb_content_status_history' #database table name
            
            #associations
            belongs_to(:content, :model => 'Content', :child_key => [:content_id])
            
            #properties
            property(:id, Serial)
            property(:content_id, Integer)
            property(:by, String)
            property(:status, Enum[:created, :draft, :published, :deleted])
            property(:date_time, String)
        end
        
        class ContentValue
            include DataMapper::Resource
            storage_names[:default] = 'tb_content_values' #database table name
            
            #associations
            belongs_to(:content, :model => 'Content', :child_key => [:content_id])
            
            #properties
            property(:id, Serial)
            property(:content_id, Integer)
            property(:name, String)
            property(:value, Text)
            
            def destroy()
                if (self.new?())
                    return
                end
                
                return super()
            end
        end
        
        class ContentType
            include DataMapper::Resource
            storage_names[:default] = 'tb_content_types' #database table name
            
            has(n, :contents, :model => 'Content', :child_key => [:type_name])
            
            property(:name, String, :key => true)
        end
    end
end