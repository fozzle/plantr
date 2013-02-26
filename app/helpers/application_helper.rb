module ApplicationHelper
  def nav_link(link_text, link_path, *args)
    class_name = current_page?(link_path) ? 'active' : ''
    class_name += ' tab-item'

    content_tag(:li, :class => class_name) do
      link_to content_tag(:div, link_text, :class => 'tab-label'), link_path, *args
    end
  end
end
