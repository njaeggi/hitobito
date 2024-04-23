#  Copyright (c) 2012-2024, Hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module PgSearchable
  def self.included(model)
    model.include PgSearch::Model

    model.pg_search_scope :search,
      against: model.const_defined?(:SEARCH_ATTRS) ? model::SEARCH_ATTRS : [],
      associated_against: model.const_defined?(:ASSOCIATED_SEARCH_ATTRS) ? 
                          model::ASSOCIATED_SEARCH_ATTRS : [],
      using: {
        tsearch: { prefix: true }
      }
  end
end