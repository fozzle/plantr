module ApplicationHelper
  def nav_link(link_text, link_path, *args)
    class_name = current_page?(link_path) ? 'ui-btn-active ui-state-persist' : ''

    link_to link_text, link_path, class: class_name, data: { transition: 'none' }
  end
end
