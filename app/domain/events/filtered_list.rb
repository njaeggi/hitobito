# frozen_string_literal: true

#  Copyright (c) 2021, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Events
  class FilteredList < ::FilteredList
    def base_scope
      Event::Course
        .group(:id)
        .select(SqlSelectStatements.new.generate_aggregate_queries("event"), 
                'MAX(event_dates.start_at)')
        .includes(:events_groups, :groups, :translations)
        .joins(:dates)
        .preload(additional_course_includes)
        .joins(additional_course_includes)
        .select(additional_course_includes.present? ? "MAX(event_kind_translations.label)" : "")
        .order(course_ordering)
    end

    def filter_scopes
      filters = [
        Events::Filter::DateRange,
        Events::Filter::State,
        Events::Filter::PlacesAvailable,
        Events::Filter::Groups,
        :list
      ]
      filters.prepend(Events::Filter::CourseKindCategory) if kind_used?
      filters
    end

    private

    def list(scope)
      scope.list
    end

    def additional_course_includes
      kind_used? ? { kind: :translations } : {}
    end

    def course_ordering
      kind_used? ? 'MAX(event_kind_translations.label), MAX(event_dates.start_at)' : 
                   'MAX(event_dates.start_at)'
    end

    def kind_used?
      @options[:kind_used] == true
    end
  end
end
