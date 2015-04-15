module Chargeover
  class Contact < Resource

    attr_accessor :user_id,
                  :external_key,
                  :first_name,
                  :last_name,
                  :middle_name_glob,
                  :name_suffix,
                  :title,
                  :email,
                  :token,
                  :phone,
                  :write_datetime,
                  :mod_datetime,
                  :name,
                  :display_as,
                  :username,
                  :customers


    self.prefix = '/user'

    def self.destroy(contact_id)
      response = delete(base_url + "/#{contact_id}")
    end

    def self.find_all_by_customer_id(customer_id)
      filter = "?where=customers.customer_id:EQUALS:#{customer_id}"

      filter += "limit=#{100}?offset=#{0}"

      response = get(base_url + filter)
      contacts = []
      response.each do |contact|
        contacts << Chargeover::Contact.find(contact['user_id'])
      end
      contacts
    end

    def update_attributes(attributes)
      response = put(base_url + "/#{self.user_id}", attributes)
      Chargeover::Contact.find(response['id'])
    end

    def customers
      cus = []
      if @customers
        @customers.each do |customer|
          cus << Chargeover::Customer.find(customer['customer_id'])
        end
      end
      cus
    end

    def has_customer?(customer_id)
      self.customers.each do |customer|
        return true if customer.customer_id.to_s == customer_id.to_s
      end
      return false
    end
  end
end