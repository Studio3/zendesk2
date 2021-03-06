# frozen_string_literal: true
class Zendesk2::Memberships
  include Zendesk2::Collection

  include Zendesk2::PagedCollection
  extend Zendesk2::Attributes

  model Zendesk2::Membership

  attribute :user_id, type: :integer
  attribute :organization_id, type: :integer

  assoc_accessor :organization
  assoc_accessor :user

  self.collection_root = 'organization_memberships'
  self.model_method    = :get_membership
  self.model_root      = 'organization_membership'

  def all(params = {})
    requires_one :user_id, :organization_id

    body = if user_id && organization_id
             {
               'organization_memberships' => [
                 cistern.get_membership(
                   'user_id' => user_id,
                   'organization_id' => organization_id,
                 ).body['organization_membership'],
               ],
             }
           elsif user_id
             request_params = { 'membership' => { 'user_id' => user_id } }.merge(params)
             cistern.get_user_memberships(request_params).body
           else
             request_params = { 'membership' => { 'organization_id' => organization_id } }.merge(params)
             cistern.get_organization_memberships(request_params).body
           end

    load(body[collection_root])
    merge_attributes(Cistern::Hash.slice(body, 'count', 'next_page', 'previous_page'))
    self
  end

  scopes << :user_id
  scopes << :organization_id
end
