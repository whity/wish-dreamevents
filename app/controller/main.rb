module WDE
    module Controllers
        class Main < Controller
            before() do
                @menu_selected = nil
                @sidebar_widgets = ["blog_recents_widget"]
            end
            
            get('/?') do
                @menu_selected = nil
                
                erubis(:index)
            end
        end
    end
end
