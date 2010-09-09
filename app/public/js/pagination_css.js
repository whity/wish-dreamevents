function Pagination(number_pages, display_entries, current_page, dyn_args)
{
    this._number_pages = number_pages;
    //this._total_items = total_items;
    //this._per_page = per_page;
    this._display_entries = display_entries;
    this._current_page = current_page;
    this._callback = function() { return true; };
    
    this._first_text = "first";
    this._last_text = "last";
    this._prev_text = "<<";
    this._next_text = ">>";
    //this._active_class = null;
    this._base_url = null;
    
    this._first_and_last = true; //to show first and last links
    
    //dynamic args
    if (dyn_args)
    {
        if (dyn_args['callback'] && typeof(dyn_args['callback']) == 'function')
            this._callback = dyn_args['callback'];
        
        //string params, assign it dynamically
        var check_args = ['first_text', 'last_text', 'prev_text', 'next_text', 'base_url']; //active_class
        var obj = this;
        
        $.each(check_args, function(idx, value) {
            if (dyn_args[value])
            {
                eval("obj._" + value + " = \"" + dyn_args[value] + "\";");
            }
        });
        //
            
        if (dyn_args['first_and_last'] != null)
            this._first_and_last = dyn_args['first_and_last'];
    }
    
    
    //methods
    this.number_of_pages = function()
    {
        //return Math.ceil(this._total_items / this._per_page);
        return this._number_pages;
    }
    
    this.current_page = function(page)
    {
        if (page && (page >= 1 && page <= this.number_of_pages()) )
            this._current_page = page;
            
        return this._current_page;
    }
    
    this.get_interval = function()
    {
        var nbr_of_pages = this.number_of_pages();
        
        var half_entries = parseInt(this._display_entries / 2);
        var start = this._current_page - half_entries;
        if (start < 1)
            start = 1;
            
        var end = start + (this._display_entries - 1);
        
        //decrease end to the maximum number of pages, if needed
        var diff = 0;
        while (end > nbr_of_pages)
        {
            end -= 1;
            diff += 1;
        }
        ///
        
        //decrease start to include difference from end to number of pages
        var counter = 0;
        while (start > 1 && counter < diff)
        {
            start -= 1;
            counter += 1;
        }
        //
        
        return [start, end];
    }
    
    this._build_url = function()
    {
        var url = this._base_url;
        if (url == null) //is is null use window.location.href
            url = window.location.href;
        
        //remove page=1, if exists
        url = url.replace(/[&|?]page=\d*/, "");
                  
        return url;
    }
    
    this._page_selected = function(url, page_id, container, event)
    {
        //this._current_page = page_id;
        //this.render(container);
        var continuePropagation = this._callback(this, url, page_id, container, event);
        
        return continuePropagation;
    }
    
    this._set_page_link = function(container, object, page)
    {
        var base_url = this._build_url();
        var pager = this;
        
        
        //check for ?
        var pos_start_args = base_url.indexOf('?');
        if (pos_start_args != -1 && pos_start_args < base_url.length)
        {
            base_url += "&";
        }
        else if (pos_start_args == -1)
        {
            base_url += '?';
        }
        //////
        
        var url = base_url + "page=" + page; 
        
        // This helper function returns a handler function that calls callback with the right page_id
        var get_click_handler = function(page_id)
                                {
                                    return function(evt){ return pager._page_selected(url, page_id, container, evt); }
                                };
        
        $(object).attr('href', url);
        $(object).bind('click', get_click_handler(page));
        
        return $(object);
    }
    
    this.render = function(container)
    {
        var container_obj = $('#' + container);
        var nbr_of_pages = this.number_of_pages();
        
        //clean links container
        $(container_obj).html("");
        
        //only 1 page, doesn't show the links
        if (nbr_of_pages <= 1)
            return;
        
        var start_end = this.get_interval();
        for (var idx = start_end[0]; idx <= start_end[1]; idx++)
        {
            //var url = base_url + "page=" + idx;
            var elem = $("<a></a>");
            this._set_page_link(container_obj, elem, idx);
            
            if (idx == this._current_page) //set selected page with bold
            {
                $(elem).attr('class', 'active');
            }
            
            var space = "";
            if (idx > 1)
                space = "&nbsp;";
            
            $(elem).html(idx);
            $(container_obj).append(elem);
            $(elem).before(space);
        }
        
        //insert previous/next links
        if (this._current_page > 1)
        {
            var obj = $("<a class='previous'>" + this._prev_text + "</a>&nbsp;");
            this._set_page_link(container_obj, obj, this._current_page - 1);
            $(container_obj).prepend("&nbsp;");
            $(container_obj).prepend(obj);
        }
        
        if (this._current_page < nbr_of_pages)
        {
            var obj = $("<a class='next'>" + this._next_text + "</a>&nbsp;");
            this._set_page_link(container_obj, obj, this._current_page + 1);
            $(container_obj).append("&nbsp;");
            $(container_obj).append(obj);
        }
        ///
        
        //check if is to show first and last links
        if (this._first_and_last == true)
        {
            //insert first/last links
            $(container_obj).prepend("&nbsp;");
            $(container_obj).prepend(this._set_page_link(container_obj, $("<a class='first'>" + this._first_text + "</a>"), 1));
            
            $(container_obj).append("&nbsp;");
            $(container_obj).append(this._set_page_link(container_obj, $("<a class='last'>" + this._last_text + "</a>"), nbr_of_pages));
            //
        }
    }
}