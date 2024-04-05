# frozen_string_literal: true

#  Copyright (c) 2024, Schweizer Alpen-Club. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito

require 'spec_helper'

describe Event::CourseResource, type: :resource do
  include Rails.application.routes.url_helpers
  let(:course) { events(:top_course) }

  describe 'serialization' do
    before do
      params[:filter] = { id: { eq: course.id } }
    end

    let(:serialized_attrs) do
      [
        :applicant_count,
        :application_closing_at,
        :application_contact_id,
        :application_opening_at,
        :application_conditions,
        :description,
        :kind_id,
        :name,
        :cost,
        :created_at,
        :group_ids,
        :leaders,
        :location,
        :maximum_participants,
        :minimum_participants,
        :motto,
        :number,
        :participant_count,
        :training_days,
        :teamer_count,
        :external_application_link,
        :state,
        :type,
        :updated_at
      ]
    end

    it 'works' do
      render
      data = jsonapi_data[0]

      expect(data.attributes.symbolize_keys.keys).to match_array [:id,
                                                                  :jsonapi_type] + serialized_attrs

      expect(data.id).to eq(course.id)
      expect(data.jsonapi_type).to eq('courses')
      expect(data.attributes['type']).to eq 'Event::Course'
    end

    describe 'leaders' do
      def create_role(type, **attrs)
        person = Fabricate(:person, attrs)
        participation = Fabricate(:event_participation, person: person, event: course, active: true)
        "Event::Role::#{type.to_s.classify}".constantize.create(participation: participation)
      end

      it 'is empty when no leaders are present' do
        event_roles(:top_leader).destroy!
        render
        expect(jsonapi_data[0].attributes['leaders']).to be_empty
      end

      it 'contains only leader roles' do
        create_role(:assistant_leader, first_name: 'assi', last_name: nil)
        create_role(:cook)
        render
        expect(jsonapi_data[0].attributes['leaders']).to match_array [
          'Bottom Member',
          'assi'
        ]
      end
    end
  end
end
