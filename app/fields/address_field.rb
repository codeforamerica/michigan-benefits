require "administrate/field/base"

class AddressField < Administrate::Field::Polymorphic
  def address_type
    data.address_type
  end

  def city
    data.city
  end

  def county
    data.county
  end

  def zip
    data.zip
  end

  def state
    data.state
  end

  def street_address
    data.street_address
  end

  def street_address_2
    data.street_address_2
  end
end
