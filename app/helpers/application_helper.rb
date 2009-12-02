module ApplicationHelper
  # Applies an html class attribute where the controller name contains the 'tab_name'.
  def tab_on(tab_name, html_class="current_page_item")
    controller_name.match(Regexp.new("#{tab_name}")) ? " class=\"#{html_class}\"" : ''
  end

  def element_id(obj, field="")
    obj.class.to_s + '_' + obj.id.to_s + (field.blank? ? '' : '_' + field)
  end
end

