#  Copyright (c) 2020, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

# == Schema Information
#
# Table name: mailing_lists
#
#  id                                  :integer          not null, primary key
#  additional_sender                   :string
#  anyone_may_post                     :boolean          default(FALSE), not null
#  delivery_report                     :boolean          default(FALSE), not null
#  description                         :text
#  filter_chain                        :text
#  mail_name                           :string
#  mailchimp_api_key                   :string
#  mailchimp_forgotten_emails          :text
#  mailchimp_include_additional_emails :boolean          default(FALSE)
#  mailchimp_last_synced_at            :datetime
#  mailchimp_result                    :text
#  mailchimp_syncing                   :boolean          default(FALSE)
#  main_email                          :boolean          default(FALSE)
#  name                                :string           not null
#  preferred_labels                    :string
#  publisher                           :string
#  subscribable_for                    :string           default("nobody"), not null
#  subscribable_mode                   :string
#  subscribers_may_post                :boolean          default(FALSE), not null
#  group_id                            :integer          not null
#  mailchimp_list_id                   :string
#
# Indexes
#
#  index_mailing_lists_on_group_id  (group_id)
#

class MailingListSerializer < ApplicationSerializer
  schema do
    json_api_properties

    map_properties :name,
      :description,
      :publisher,
      :mail_name,
      :additional_sender,
      :subscribable_for,
      :subscribable_mode,
      :subscribers_may_post,
      :anyone_may_post,
      :preferred_labels,
      :delivery_report,
      :main_email

    property :subscribable, item.subscribable?

    entity :group, item.group, GroupLinkSerializer
    entities :subscribers,
      item.people.includes(subscribers_includes),
      MailingListSubscriberSerializer,
      mailing_list: item
  end

  private

  def subscribers_includes
    [:primary_group]
  end
end
