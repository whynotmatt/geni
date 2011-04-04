module Geni
  class Union < Base
    attr_reader :id, :status, :marriage_location, :marriage_date, :marriage_date_parts
                
    def partners
      @partner_profiles ||= client.get_profile(partner_ids)
    end
    
    def children
      @children_profiles ||= client.get_profile(children_ids)
    end

    def partner_ids
       @partners.collect { |uri| uri.split('-').last }
    end

    def children_ids
      @children.collect { |uri| uri.split('-').last }
    end
  end
end