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

  def options_from_calendar_for_select
    results = []
    sort_list(Calendar.all, :name).each do |c|
      results << [
        (content_tag(:i, "", :class => "fa fa-fw fa-angle-right") * c.level + c.name).html_safe,
        c.id,
        style: "border-left: 5px solid #{c.color}"
      ]
    end
    results
  end

  def render_list(hash, options = {}, &block)
    sort_proc = options.delete(:sort)

    hash.keys.sort_by(&sort_proc).each do |node|
      block.call node
      render_list(hash[node], :sort => sort_proc, &block)
    end if hash.present?
  end


  def sort_list(objects, order)
    # Partition objects
    children_of = {}
    objects.each do |o|
      children_of[o.parent_id] ||= []
      children_of[o.parent_id] << o
    end

    # Sort each children list
    children_of.each_value do |children|
      children.sort_by! &order
    end

    # Re-join them into a single list
    results = []
    recombine_lists(results, children_of, nil)
    results
  end

  def recombine_lists(results, children_of, parent_id)
    if children_of[parent_id] then
      children_of[parent_id].each do |o|
        results << o
        recombine_lists(results, children_of, o.id)
      end
    end
  end
end
