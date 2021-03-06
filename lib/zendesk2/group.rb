# frozen_string_literal: true
class Zendesk2::Group
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when creating groups
  identity :id, type: :integer

  # @return [Time] The time the group was created
  attribute :created_at, type: :time
  # @return [Boolean] Deleted groups get marked as such
  attribute :deleted, type: :boolean
  # @return [String] The name of the group
  attribute :name, type: :string
  # @return [Time] The time of the last update of the group
  attribute :updated_at, type: :time
  # @return [String] The API url of this group
  attribute :url, type: :string

  def save!
    data = if new_record?
             requires :name

             cistern.create_group('group' => attributes)
           else
             requires :identity

             cistern.update_group('group' => attributes)
           end.body['group']

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    cistern.destroy_group('group' => { 'id' => identity })

    self.deleted = true
  end

  def destroyed?
    deleted
  end
end
