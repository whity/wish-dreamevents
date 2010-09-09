module WDE
    module Helpers
        module Widgets
            def menu_widget()
                template_vars = Hash.new()
                
                template_vars[:menu_items] = [{'id' => nil,    'label' => "inicio"},
                                              {'id' => 'blog', 'label' => "blog"}
                                             ]
                
                
                return erubis(:menu, :layout => false, :locals => template_vars)
            end
            
            def main_tabs_admin_widget()
                tabs = [{'id' => nil,    'label' => 'Dashboard'},
                        {'id' => 'blog', 'label' => 'Blog'},
                        ]
                
                return erubis("widgets/main_tabs".to_sym(),
                              :layout => false,
                              :locals => {:tabs => tabs})
            end
            
            def blog_archive_widget()
                archives = repository(:default).adapter.select('SELECT DISTINCT (substr(status_dt, 1, 7))' \
                                                               + ' FROM tb_contents ORDER BY status_dt desc')
                
                #convert each archive item to Time object
                total_items = archives.length
                total_items.downto(1) do |idx|
                    idx -= 1
                    
                    item = archives[idx] + "-01"
                    archives[idx] = Time.parse(item)
                end
                
                return erubis("widgets/blog_archive".to_sym(),
                              :layout => false,
                              :locals => {:archives => archives})
            end
            
            def blog_recents_widget()
                posts = Model::Post.published(:limit => 5)
                
                return erubis("widgets/blog_recents".to_sym(),
                              :layout => false,
                              :locals => {:posts => posts})
            end
            
            def admin_blog_form_filters(default_status)
                form_data = {:status => default_status,
                             :query  => ""
                            }
                
                available_status = Model::Post.available_status()
                available_status.delete_at(0)
                available_status = ['all'] + available_status
                
                if (self.request.request_method().match(/post/i))
                    form_data[:status] = self.request.params['status'].to_sym()
                    form_data[:query]  = self.request.params['query']
                end
                
                return erubis("widgets/blog_form_filters".to_sym(),
                              :layout => false,
                              :locals => {:form_data        => form_data,
                                          :available_status => available_status
                                          }
                              )
            end
            
            #def paginator_widget(total_pages, current_page)
            #    return erubis("paginator".to_sym(),
            #                  :layout => false,
            #                  :locals => {:total_pages  => total_pages,
            #                              :current_page => current_page
            #                             })
            #end
        end
    end
end