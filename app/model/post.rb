module WDE
    module Model
        class Post < Content
            def save(*args)
                if (self.text != nil)
                    #calculate truncate, must be 20% of text length
                    total = self.text.length
                    needed = (total * 30) / 100
                    
                    self.summary = self.text.truncate_html(needed, :tail => '')
                    
                    #strip spaces
                    self.summary.strip!()
                    
                    #get last paragraph, and add '...'
                    self.summary.gsub!(/<\/p>$/, '...</p>')
                else
                    self.summary = nil
                end
                
                super(*args)
            end
            
            def self.published(conditions={})
                if (!conditions.has_key?("categories.path"))
                    conditions["categories.path" => '/blog/']
                end
                
                #force status
                conditions[:status] = :published
                
                if (!conditions.has_key?(:order))
                    conditions[:order] = [:updated.desc]
                end
                
                return self.all(conditions)
            end
            
            custom_fields_accessors(['summary', 'text'])
            
            #validations
            validates_with_method(:text, :method => :_validates_text)
            
            protected
            
                def _validates_text()
                    tmp_text = self.text
                    
                    #strip html
                    tmp_text = Sanitize.clean(tmp_text).strip()
                    
                    if (tmp_text.length > 0)
                        return [true]
                    end
                    
                    return [false, 'Text is required']
                end
        end
    end
end