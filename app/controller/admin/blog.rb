module WDE
    module Controllers
        module Admin
            class Blog < BaseAdmin
                before() do
                    @menu_selected = "blog"
                end
                
                get_or_post('/?') do
                    return self._get_post_list()
                end
                
                get_or_post('/edit/:id/?') do |id|
                    #get post to edit
                    post = Model::Post.get(id)
                    (success, temp_locals) = self._add_edit(post)
                    if (success)
                        #set flash message and redirect to posts blog
                        flash[:message] = "post successfully updated."
                        redirect('/admin/blog/')
                    end
                    
                    temp_locals[:extra_title] = " - Editing Post"
                    
                    return erubis("blog/add_edit".to_sym(), :locals => temp_locals)
                end
                
                get_or_post('/add/?') do
                    (success, temp_locals) = self._add_edit()
                    if (success)
                        #set flash message and redirect to posts blog
                        flash[:message] = "post successfully added."
                        redirect('/admin/blog/')
                    end
                    
                    temp_locals[:extra_title] = " - Adding Post"
                    
                    return erubis("blog/add_edit".to_sym(), :locals => temp_locals)
                end
                
                protected
                    def _delete_selected_posts()
                        if (self.request.params['selected'])
                            selected = self.request.params['selected']
                            
                            #convert to an array of integers
                            selected.each_index() do |idx|
                                selected[idx] = selected[idx].to_i()
                            end
                            
                            Model::Post.transaction() do
                                #delete posts
                                posts = Model::Post.all(:id.in => selected)
                                posts.each() do |post|
                                    #if post already delete, continue to next one
                                    if (post.status == :deleted)
                                        next
                                    end
                                    
                                    post.status = :deleted
                                    post.updated_by = @user.username
                                    post.save()
                                end
                            end
                        end
                        
                        return true
                    end
                
                    def _get_post_list()
                        ####build search###
                        default_status = :published
                        filter_data = {:status => nil,
                                       :query  => nil
                                      }
                        
                        posts = Model::Post.all()
                        
                        if (self.request.request_method().match(/post/i) &&
                            self.request.params['_submit'])
                            action = self.request.params['action']
                            
                            if (action == 'delete')
                                #delete selected posts
                                self._delete_selected_posts()
                            end
                            
                            #check post status to show
                            if (self.request.params['status'])
                                filter_data[:status] = self.request.params['status'].to_sym()
                            end
                            
                            #check query
                            if (self.request.params['query'] && self.request.params['query'].length > 0)
                                filter_data[:query] = self.request.params['query']
                            end
                        else
                            filter_data[:status] = default_status
                        end
                        
                        #filter by status
                        if (filter_data[:status] != nil &&
                            filter_data[:status] != :all)
                            posts = posts.all(:status => filter_data[:status])
                        end
                        
                        #filter by query (text on 'title' or 'text' columns)
                        if (filter_data[:query] != nil)
                            posts = posts.all(:title.like => "%#{ filter_data[:query] }%") \
                                    + posts.all(:content_values => {:name       => 'text',
                                                                    :value.like => "%#{ filter_data[:query] }%"})
                        end
                        ######
                        
                        #set posts order by
                        posts = posts.all(:order => [:updated.desc])
                        
                        #get page number to get/view
                        page = list_page_to_get()
                        
                        #get posts list (published by default)
                        (posts, total_pages) = Model::Post.get_page(posts, 8, page)
                        
                        return self.erubis("blog/index".to_sym(), :locals => {:posts            => posts,
                                                                              :total_pages      => total_pages,
                                                                              :current_page     => page,
                                                                              :default_status   => default_status,
                                                                              :filter_data      => filter_data
                                                                             }
                                           )
                    end
                    
                    def _add_edit(post=nil)
                        form_data = {:title  => "",
                                     :text   => "",
                                     :status => :published
                                    }
                        form_errors = {}
                        
                        if (self.request.request_method().match(/post/i) && self.request.params['_submit'])
                            #get form posted data
                            posted_form_data(self.request.params, form_data)
                            
                            if (!post)
                                #get blog category
                                blog_catg = Model::Category.first(:path => '/blog/')
                                
                                #add new post
                                post = Model::Post.new()
                                
                                #associate to blog category
                                post.categories << blog_catg
                            end
                            
                            #set new post data
                            post.title = form_data[:title]
                            post.text = form_data[:text]
                            post.status = form_data[:status].to_sym()
                            post.updated_by = @user.username
                            
                            if (post.valid?())
                                post.save()
                                return [true]
                            else
                                #get the error for each field
                                errors = post.errors()
                                errors.each_key() do |key|
                                    form_errors[key] = errors[key][0]
                                end
                            end
                        elsif (post) #entering in form, if editing set post data
                            form_data.each() do |key, value|
                                form_data[key] = post.send(key)
                            end
                        end
                        
                        return [false, {:form_data        => form_data,
                                        :form_errors      => form_errors,
                                        :available_status => Model::Post.available_status()
                                        }]
                    end
            end #end class definition
        end
    end
end
