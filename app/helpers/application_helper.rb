module ApplicationHelper
  def nav_link(link_text, link_path, *args)
    class_name = current_page?(link_path) ? 'ui-btn-active' : ''

    link_to link_text, link_path, :class => class_name
  end
end
