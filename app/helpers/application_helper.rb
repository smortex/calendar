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

  def markdown(text)
    @@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), :autolink => true, :no_intra_emphasis => true, :fenced_code_blocks => true, :lax_spacing => true)
    @@markdown.render(text).html_safe
  end

  def title(page_title)
    content_for(:title) { page_title }
    content_tag(:div, :class => "page-header") do
      content_tag(:h1, page_title)
    end
  end
end
