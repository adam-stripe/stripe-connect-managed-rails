module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty? 
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      html = <<-HTML
      <div id="error_explanation" class="alert alert-danger">
        <a href="#" data-dismiss="alert" class="close">×</a>
        <ul class="list-unstyled"></i> #{messages}</ul>
      </div>
      HTML
    html.html_safe
  end
end