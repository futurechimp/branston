module ApplicationHelper
  # Applies an html class attribute where the controller name contains the 'tab_name'.
  def tab_on(tab_name, html_class="current_page_item")
    controller_name.match(Regexp.new("#{tab_name}")) ? " class=\"#{html_class}\"" : ''
  end

  # Produces a string id using the type and id of obj plus any field suffix supplied useful when
  # assigning html ids on index pages.
  # e.g. element_id(user, 'name') => 'User_23_name'
  def element_id(obj, field="")
    obj.class.to_s + '_' + obj.id.to_s + (field.blank? ? '' : '_' + field)
  end

  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              id="clippy" >
      <param name="movie" value="/flash/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="text=#{text}">
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/flash/clippy.swf"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="text=#{text}"
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
  end

end

