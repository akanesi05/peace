module ApplicationHelper
  def page_title(title = "")
    base_title = "ピス卒"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
