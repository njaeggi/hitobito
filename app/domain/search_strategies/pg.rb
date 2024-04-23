#  Copyright (c) 2012-2024, Hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module SearchStrategies
  class Pg < Base

    def query_people
      return Person.none.page(1) unless term_present?

      pg_rank_alias = extract_pg_ranking(Person.search(@term).to_sql)

      search_results = Person.search(@term)
      
      entries = search_results
                  .accessible_by(PersonReadables.new(@user))
                  .select(pg_rank_alias) # add pg_search rank to select list of base query again

      if Ability.new(@user).can?(:index_people_without_role, Person)
        entries += search_results.where('NOT EXISTS (SELECT * FROM roles ' \
                   "WHERE (roles.deleted_at IS NULL OR
                           roles.deleted_at > :now) AND
                          roles.person_id = people.id)", now: Time.now.utc.to_s(:db))
      end

      entries += Group::DeletedPeople.deleted_for_multiple(
        deleted_people_indexable_layers
      ) & search_results

      entries.uniq
    end

    def query_groups
      return Group.none.page(1) unless term_present?

      Group.search(@term)
    end

    private

    # extract first order by value to reselect in permission checked query
    def extract_pg_ranking(query)
      match = query.match(/ORDER BY (\w+\.\w+)/)
      return match[1] if match
      nil
    end
  end
end