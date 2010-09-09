module WDE
    module Controllers
        class Blog < Controller
            before() do
                @menu_selected = "blog"
                @sidebar_widgets = ["blog_archive_widget"]
            end
            
            get('/?') do
                return self._get_posts()
            end
            
            get(%r{/(\d+)/(\d+)/?}) do |year, month|
                return self._get_posts({:status_dt.like => "#{ year }-#{ month }%"})
            end
            
            get('/view/:id/?') do |id|
                #get post object
                post = Model::Post.first(:id => id, :status => :published)
                if (!post)
                    #redirect to blog index if invalid post id
                    redirect('/blog/')
                end
                
                return erubis("blog/view".to_sym(), :locals => {:post => post})
            end
            
            protected
                
                def _get_posts(search_conditions={})
                    #get page to show
                    page = list_page_to_get()
                    
                    #get all posts associated to gallery /blog/
                    (posts, total_pages) = Model::Post.get_page(Model::Post.published(search_conditions), 15, page)
                    
                    return erubis("blog/list".to_sym(), :locals => {:posts        => posts,
                                                                    :total_pages  => total_pages,
                                                                    :current_page => page
                                                                    })
                end
        end
    end
end
