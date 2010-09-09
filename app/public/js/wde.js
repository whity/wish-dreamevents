function blog_change_page(obj, url, page, container, event)
{
    var $frm = $('#frmPostList');
    $(':input[name=page]', $frm).val(page);
    
    $frm.submit();
    
    return false;
}