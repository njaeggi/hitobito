# frozen_string_literal: true

#  Copyright (c) 2012-2020, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class HitobitoThemesController < SimpleCrudController
  self.permitted_attrs = [:name, :link_color, :link_hover_color, :primary_color, :secondary_color, :page_background_color, :content_background_color, :footer_background_color]
end
