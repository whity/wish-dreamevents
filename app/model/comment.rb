module WDE        
    module Model
        class Comment
            include DataMapper::Resource
            storage_names[:default] = 'tb_content_comments' #database table name
            
            #associations
            belongs_to(:content, :model => 'Content', :child_key => [:content_id])
            has(1, :parent, :model => 'Comment', :child_key => [:parent_id])
            has(1, :_path, :model => 'CommentPath', :child_key => [:comment_id])
            
            before(:save) do
                if (self.parent)
                    self.parent_id = self.parent.id
                end
            end
            
            #properties
            property(:id, Serial)
            property(:content_id, Integer)
            property(:parent_id, Integer)
            property(:name, String)
            property(:text, String)
            
            def path()
                return self._path.value
            end
            
            def path=(value)
                self._path.value = value
                
                return value
            end
            
            def save(*args)
                #exec_code = Proc.new() do
                exec_code = lambda() do
                    new_comment = false
                    if (self.new?())
                        new_comment = true
                    end
                    
                    if (!super(*args)) #execute parent save
                        return false #stop proc process, and return false
                    end
                    
                    if (new_comment && !self._calculate_path())
                        return false
                    end
                    
                    return true #stop process returning true
                end
                
                save_result = false
                cur_trans = self.repository.adapter.current_transaction()
                if (!cur_trans)
                    Comment.transaction() do |trans|
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
            
                def _calculate_path()
                    #get parent obj, if defined
                    parent_obj = nil
                    cmt_path = ""
                    
                    if (self.parent)
                        parent_obj = self.parent
                    elsif (self.parent_id)
                        parent_obj = Comment.get(self.parent_id)
                    end
                    
                    #calculate path
                    if (parent_obj)
                        cmt_path = parent_obj.path + self.id.to_s()
                    else
                        cmt_path = '/' + self.id.to_s()
                    end
                    
                    cmt_path += '/'
                    
                    c_path = CommentPath.new(:comment_id => self.id, :value => cmt_path)
                    
                    return c_path.save()
                end
            
        end #end class definition
        
        class CommentPath
            include DataMapper::Resource
            storage_names[:default] = 'tb_comments_path' #database table name
            
            #associations
            belongs_to(:comment, :model => 'Comment', :child_key => [:comment_id])
            
            property(:comment_id, Integer)
            property(:value, String)
        end
        
    end
end