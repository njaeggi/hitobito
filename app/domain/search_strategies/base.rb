# frozen_string_literal: true

#  Copyright (c) 2012-2024, Hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module SearchStrategies
  class Base

    MIN_TERM_LENGTH = 3

    QUERY_PER_PAGE = 10

    attr_accessor :term

    def initialize(user, term, page)
      @user = user
      @term = term
      @page = page
    end

    def query_people
      # override
      Person.none.page(1)
    end

    def query_groups
      # override
      Group.none.page(1)
    end

    def query_events
      # override
      Event.none.page(1)
    end

    def query_addresses
      # override
      Address.none.page(1)
    end

    def query_invoices
      # override
      Invoice.none.page(1)
    end

    protected

    def term_present?
      @term.present? && @term.length >= MIN_TERM_LENGTH
    end

    def deleted_people_indexable_layers
      accessible_layers.select do |layer|
        Ability.new(@user).can?(:index_deleted_people, layer)
      end
    end

    def accessible_layers
      @user.groups.flat_map(&:layer_hierarchy)
    end
  end
end
