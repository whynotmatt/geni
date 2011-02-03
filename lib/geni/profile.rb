module Geni
  class Profile < Base
    attr_reader :id
    attr_reader :first_name
    attr_reader :middle_name
    attr_reader :maiden_name
    attr_reader :last_name
    attr_reader :suffix
    attr_reader :display_name
    attr_reader :name
    attr_reader :gender
    attr_reader :current_residence
    attr_reader :created_by
    attr_reader :managers
    attr_reader :merged_into
    attr_reader :requested_merges
    attr_reader :merge_note
    attr_reader :public
    attr_reader :big_tree
    attr_reader :claimed
    attr_reader :locked
    attr_reader :birth_date
    attr_reader :birth_location
    attr_reader :birth_location
    attr_reader :death_date
    attr_reader :death_location
    attr_reader :burial_date
    attr_reader :url
    attr_reader :language
    attr_reader :curator

    def name
      "#{first_name} #{last_name}"
    end
    
    def father
      #immediate_family.nodes["profile-#{id}"]
    end
    
    def mother
      
    end
    
    def children
      
    end
    
    def partners
      
    end

    def immediate_family
      @immediate_family ||= Geni::Family.new({
        :access_token => @access_token,
        :attrs        => @access_token.get("/api/profile-#{id}/immediate-family")
      })
    end
  end
end