module ApplicationHelper
  def nav_link(link_path)
    class_name = current_page?(link_path) ? 'ui-btn-active ui-state-persist' : ''

    link_to link_path, class: class_name, data: { transition: 'none' } do
      yield if block_given?
    end
  end
end
