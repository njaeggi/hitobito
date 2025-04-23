class ThemesController < ApplicationController
  skip_authorization_check

  def stylesheet
    @theme = HitobitoTheme.first
    render plain: <<~CSS, content_type: "text/css"
      :root {
        --bs-link-color: #{@theme.link_color};
        --bs-link-hover-color: #{@theme.link_hover_color};
        --hitobito-primary-color: #{@theme.primary_color};
        --hitobito-secondary-color: #{@theme.secondary_color};
        --hitobito-footer-background: #{@theme.footer_background_color};
        --hitobito-body-background: #{@theme.page_background_color};
        --hitobito-content-background: #{@theme.content_background_color};
        --bs-nav-pills-link-active-bg: #{@theme.primary_color} !important;
      }
    CSS
  end
end