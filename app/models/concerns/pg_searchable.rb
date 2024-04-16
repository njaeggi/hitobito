module PgSearchable
  def self.included(model)
    model.include PgSearch::Model

    model.pg_search_scope :search,
      against: model::SEARCH_ATTRS,
      associated_against: model::ASSOCIATED_SEARCH_ATTRS,
      using: {
        tsearch: { prefix: true }
      }
  end
end