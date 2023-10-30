module Serializable
  extend ActiveSupport::Concern

  private

  def serialize(resource, conditions)
    ActiveModelSerializers::SerializableResource.new(resource, conditions)
  end
end