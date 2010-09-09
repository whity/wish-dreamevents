#extend ruby standard Time class
class Time
    def self.days_of_month(year, month)
        #year and month must be integers
        if (!year.kind_of?(Integer))
            raise(ArgumentError, "invalid argument, 'year', expecting integer.")
        end
        
        if (!month.kind_of?(Integer))
            raise(ArgumentError, "invalid argument, 'month', expecting integer.")
        end
        
        #if december, increment year, and set month to january
        if (month == 12)
            year += 1
            month = 1
        else #increment month
            month += 1
        end
        
        #max days on month = next month, first day minus 1
        days = (Time.gm(year, month, 1) - 1).day()
        
        return days
    end
end

class String
    #encode to entities
    def encode_entities()
        coder = HTMLEntities.new()
        
        #convert special chars to html entities
        result = coder.encode(self, :named)
        
        return result
    end
    
    def decode_entities()
        coder = HTMLEntities.new()
        
        #convert html entities to chars
        result = coder.decode(self)
        
        return result
    end
    
    #replaces accents chars by non accents chars
    def sanitize(options={})
        coder = HTMLEntities.new()
        
        #lowercase it
        encoded = self.downcase()
        
        #convert special chars to html entities
        encoded = coder.encode(encoded, :named)
        
        #replace spaces by _ (underscore)
        encoded = encoded.gsub(/\s+/i, '_')
        
        while ((found = encoded.match(/&([^&;]+);/i)))
            #char without accent, is the first in the html entity definition
            char = found[1][0]
            
            char_ord = coder.decode(found[0]).ord()
            if ( (char_ord >= 192 && char_ord <= 214) ||
                 (char_ord >= 216 && char_ord <= 223) ||
                 (char_ord >= 224 && char_ord <= 246) ||
                 (char_ord >= 248 && char_ord <= 255)
                )
                #valid character
            else
                char = "_"
            end
            
            #replace encoded
            encoded = encoded.gsub(/#{ Regexp.escape(found[0]) }/, char)
        end
        
        return encoded
    end
    
    # Truncate strings containing HTML code
    # Usage example: "string".truncate_html(50, :word_cut => false, :tail => '[+]')
    def truncate_html(len = 30, opts = {})
        opts = {:word_cut => true, :tail => ' ...'}.merge(opts)
        p = REXML::Parsers::PullParser.new(self)
        tags = []
        new_len = len
        results = ''
        while p.has_next? && new_len > 0
            p_e = p.pull
            case p_e.event_type
                when :start_element
                    tags.push p_e[0]
                    results << "<#{tags.last} #{attrs_to_s(p_e[1])}>"
                when :end_element
                    results << "</#{tags.pop}>"
                when :text
                    text = HTMLEntities.decode_entities(p_e[0])
                    if (text.length > new_len) and !opts[:word_cut]
                        piece = text[0 .. text.index(' ', new_len)]
                        #piece = text.first(text.index(' ', new_len))
                    else
                        #piece = text.first(new_len)
                        piece = text[0 .. new_len]
                    end
                    results << HTMLEntities.encode_entities(piece)
                    new_len -= text.length
                else
                    results << "<!-- #{p_e.inspect} -->"
                end
            end
            tags.reverse.each do |tag|
            results << "</#{tag}>"
        end
        results << opts[:tail]
        
        return results
    end
  
    private
  
        def attrs_to_s(attrs)
            if attrs.empty?
                return ''
            else
                return attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')
            end
        end
end
