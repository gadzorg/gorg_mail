class MaterializeLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  def prepare(collection, options, template)

    options[:previous_label]=tag(:i,'chevron_left',class: "material-icons")
    options[:next_label]=tag(:i,'chevron_right',class: "material-icons")
    super(collection, options, template)

  end

  def url(target)
    @base_url_params ||= begin
      url_params = merge_get_params(default_url_params)
      url_params[:only_path] = true
      merge_optional_params(url_params)
    end

    url_params = @base_url_params.dup
    add_current_page_param(url_params,  target)

    @template.url_for(url_params)
  end

  def html_container(html)
    tag(:ul, html, container_attributes)
  end

  def page_number(page)

    classes= page==current_page ?
        "active" :
        "waves-effect"


    tag(:li,link(page, page, :rel => rel_value(page)),class: classes)
  end


  def previous_or_next_page(page, text, classname)
    if page
      tag(:li,link(text,page), class: "waves-effect")
    else
      tag(:li,link(text,'#!'), class: "disabled")
    end
  end

  GET_PARAMS_BLACKLIST = [:script_name, :original_script_name]

  def default_url_params
    {}
  end

  def merge_get_params(url_params)
    if @template.respond_to? :request and @template.request and @template.request.get?
      symbolized_update(url_params, @template.params, GET_PARAMS_BLACKLIST)
    end
    url_params
  end

  def merge_optional_params(url_params)
    symbolized_update(url_params, @options[:params]) if @options[:params]
    url_params
  end

  def add_current_page_param(url_params, page)
    unless param_name.index(/[^\w-]/)
      url_params[param_name.to_sym] = page
    else
      page_param = parse_query_parameters("#{param_name}=#{page}")
      symbolized_update(url_params, page_param)
    end
  end

  private

  def parse_query_parameters(params)
    Rack::Utils.parse_nested_query(params)
  end


end