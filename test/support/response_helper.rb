# frozen_string_literal: true

require 'nori'

module ResponseHelper
  def self.load(file_name)
    File.read("#{Dir.pwd}/test/fixtures/responses/#{file_name}")
  end

  def self.parse(response_xml)
    parser = Nori.new(delete_namespace_attributes: true,
                      convert_tags_to: ->(tag) { tag.snakecase.to_sym },
                      strip_namespaces: true)
    hash = parser.parse(response_xml)
    envelope = parser.find(hash, 'Envelope')
    parser.find(envelope, 'Body')
  end
end
