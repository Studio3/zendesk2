# frozen_string_literal: true
class Zendesk2::CreateTicketField
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/ticket_fields.json' }
  request_body { |r| { 'ticket_field' => r.ticket_field_params } }

  def self.accepted_attributes
    %w(type title description position active required collapsed_for_agents regexp_for_validation title_in_portal
       visible_in_portal editable_in_portal required_in_portal tag custom_field_options agent_description)
  end

  def ticket_field_params
    Cistern::Hash.slice(params.fetch('ticket_field'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'active'                => true,
      'collapsed_for_agents'  => false,
      'created_at'            => timestamp,
      'description'           => params['title'],
      'editable_in_portal'    => false,
      'id'                    => identity,
      'position'              => 9999,
      'regexp_for_validation' => '',
      'removable'             => true,
      'required'              => false,
      'required_in_portal'    => false,
      'tag'                   => '',
      'title_in_portal'       => params['title'],
      'updated_at'            => timestamp,
      'url'                   => url_for("/ticket_fields/#{identity}.json"),
      'visible_in_portal'     => false,
      'agent_description'     => '',
    }.merge(ticket_field_params)

    data[:ticket_fields][identity] = record

    mock_response('ticket_field' => record)
  end
end
