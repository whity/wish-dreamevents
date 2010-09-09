module WDE
    module Model
        class Base
            def self.get_page(list, limit, page)
                #calculate total of pages
                total_pages = 1
                total_items = list.count()
                total_pages = (total_items / limit.to_f())
                
                #get fraction
                fraction = total_pages.to_s().match(/\.\d+/)
                fraction = fraction[0].gsub(/\./, '').to_i()
                
                #truncate total_pages
                total_pages = total_pages.truncate()
                
                #chec if fraction if bigger than zero, if yes, increment number of pages
                if (fraction > 0)
                    total_pages = total_pages + 1
                end
                
                #calculate offset
                offset = (page - 1) * limit
                
                result = list.all(:limit => limit, :offset => offset)
                
                return [result, total_pages]
            end
            
        end
    end
end