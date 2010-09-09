module WDE
    module Helpers
        #get posted data and set it on hash form_data
        def posted_form_data(posted, form_data)
            form_data.each_key() do |key|
                str_key = key.to_s()
                
                if (posted.has_key?(str_key))
                    form_data[key] = posted[str_key]
                end
            end
        end
        
        def list_page_to_get()
            page = 1
            if (self.request.params.has_key?('page') &&
                self.request.params['page'].match(/^\d+$/i))
                page = self.request.params['page'].to_i()
            end
            
            return page
        end
    end
end