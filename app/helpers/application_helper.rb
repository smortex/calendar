module ApplicationHelper
  class PlansDecoder
    def initialize
      @coder = HTMLEntities.new
    end

    def decode(s)
      if s.nil? then
        return ""
      else
        return @coder.decode(URI.decode(s)).gsub('+', ' ')
      end
    end
  end

  def title(page_title, write_title = true)
    content_for(:title) { page_title }
    if write_title then
      content_tag(:h1, page_title)
    end
  end
end
