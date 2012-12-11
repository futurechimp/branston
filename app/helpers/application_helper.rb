module ApplicationHelper

  #
  #
  #
  # @returns [String] -
  #
  def is_active?(*controllers)
    controllers.each do |controller|
      if controller_name.match(Regexp.new("#{controller}"))
        return true
      end
    end

    return false
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

  # Translates default Padrino flash keys into default Twitter Bootstrap
  # alert CSS class name extension.
  #
  # @param [Symbol] flash - The flash key
  # @return [String] the CSS class name
  def bootstrap_alert_for(flash)
    case flash
      when :error
        return "error"
      when :warning
        return "block"
      when :notice
        return "success"
      when :info
        return "info"
    end
  end

  def add_form_object(form_builder, klass, css_class)
    text = klass.name
    fields_for = text.tableize.to_sym
    partial = "#{text.tableize}/form"
    html = ""
    form_builder.fields_for(fields_for, klass.new, :child_index => 'NEW_RECORD') do |form|
      html = render(:partial => partial, :locals => { :f => form }).gsub!('NEW_RECORD', DateTime.now.to_s.gsub!(":","").gsub!("+",""))
    end
    # debugger
    html = escape_javascript(h(html))
    # html.gsub!('\\\\', '\\')
    # html.gsub!('\\\\\\', '\\\\')

    render :partial => "shared/add_form_object", :locals => {:html => html, :css_class => css_class}
  end

  # TODO: This is also due some loving and pulling out into JS.
  def delete_item(form_builder, text, css_class)
    text = "<i class=\"icon-minus icon-white\"></i> #{text}"
    fieldset = "$(this).parent().parent().parent('fieldset')"
    if form_builder.object.new_record?
      link_to_function("#{text}", "#{fieldset}.remove()", :class => css_class)
    else
      form_builder.hidden_field(:_destroy) +
      link_to_function("#{text}", "#{fieldset}.hide(); $(this).prev().val('1');", :class => css_class)
    end
  end

end

