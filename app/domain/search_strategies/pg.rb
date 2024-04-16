module SearchStrategies
  class Pg < Base

    def query_people
      return Person.none.page(1) unless term_present?

      Person.search(@term)
    end

    def query_groups
      return Group.none.page(1) unless term_present?

      Group.search(@term)
    end
  end
end