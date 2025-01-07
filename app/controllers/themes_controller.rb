class ThemesController < ApplicationController
  skip_authorization_check
  
  def stylesheet
    @theme = HitobitoTheme.first
    render plain: <<~CSS, content_type: "text/css"
      :root {
        --bs-link-color: #{@theme.color};
        --bs-link-hover-color: #{@theme.color};
        --bs-body-color: #{@theme.color};
      }
    CSS
  end
end