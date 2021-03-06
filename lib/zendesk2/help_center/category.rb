# frozen_string_literal: true
class Zendesk2::HelpCenter::Category
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when creating categories
  identity :id, type: :integer # ro:yes required:no

  # @return [Time] The time at which the category was created
  attribute :created_at, type: :time # ro:yes required:no
  # @return [String] The description of the category
  attribute :description, type: :string # ro:no required:no
  # @return [String] The url of this category in Help Center
  attribute :html_url, type: :string # ro:yes required:no
  # @return [String] The locale that the category is displayed in
  attribute :locale, type: :string # ro:no required:yes
  # @return [String] The name of the category
  attribute :name, type: :string # ro:no required:yes
  # @return [Boolean] Whether the category is out of date
  attribute :outdated, type: :boolean # ro:yes required:no
  # @return [Integer] The position of this category relative to other categories
  attribute :position, type: :integer # ro:no required:no
  # @return [String] The source (default) locale of the category
  attribute :source_locale, type: :string # ro:yes required:no
  # @return [Array] The ids of all translations of this category
  attribute :translation_ids, type: :array # ro:yes required:no
  # @return [Time] The time at which the category was last updated
  attribute :updated_at, type: :time # ro:yes required:no
  # @return [String] The API url of this category
  attribute :url, type: :string # ro:yes required:no

  def articles
    requires :identity

    cistern.help_center_articles(category_id: identity)
  end

  def destroy!
    requires :identity

    cistern.destroy_help_center_category('category' => { 'id' => identity })
  end

  def sections
    requires :identity

    cistern.help_center_sections(category_id: identity)
  end

  def translations
    requires :identity

    cistern.help_center_translations(source_id: identity, source_type: 'Category')
  end

  def save!
    response = if new_record?
                 requires :name, :locale

                 cistern.create_help_center_category('category' => attributes)
               else
                 requires :identity

                 cistern.update_help_center_category('category' => attributes)
               end

    merge_attributes(response.body['category'])
  end
end
