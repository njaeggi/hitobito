# frozen_string_literal: true

#  Copyright (c) 2024, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Event::CourseResource < EventResource
  with_options writable: false, filterable: false, sortable: false do
    attribute :state, :string, filterable: true
    attribute :training_days, :float
    attribute :applicant_count, :integer
    attribute :participant_count, :integer
    attribute :minimum_participants, :integer
    attribute :number, :string
    attribute :teamer_count, :integer
    attribute :leaders, :array_of_strings do
      @object.participations.flat_map do |p|
        [p.person.first_name, p.person.last_name].reject(&:blank?).compact.join(' ')
      end
    end
  end

  belongs_to :kind, resource: Event::KindResource, foreign_key: :kind_id

  def base_scope
    Event::Course.all.accessible_by(index_ability).includes(:groups, :translations).list
  end

  def resolve(scope)
    leaders = Event::Participation.joins(:roles).where({
      event_roles: { type: [
        Event::Role::Leader.sti_name,
        Event::Role::AssistantLeader.sti_name
      ] }
    })
    ActiveRecord::Associations::Preloader.new.preload(leaders, :person, Person.only_public_data)
    ActiveRecord::Associations::Preloader.new.preload(scope, :participations, leaders)
    scope.to_a
  end
end
