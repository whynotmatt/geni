module Geni
  class Family < Base

    # load parent profiles
    def parents(fetch = true)
      unless fetch
        # create profile from information in immediate-family response
        shallow_profiles = []
        parent_ids.each do |id|
          shallow_profiles << Profile.new({:client=>client, :attrs=>@nodes["profile-#{id}"]})
        end
        return shallow_profiles
      else
        @parents ||= profiles(parent_ids)
      end

    end

    # load partner profiles
    def partners(fetch = true)
      unless fetch
        # create profile from information in immediate-family response
        shallow_profiles = []
        partner_ids.each do |id|
          shallow_profiles << Profile.new({:client=>client, :attrs=>@nodes["profile-#{id}"]})
        end
        return shallow_profiles
      else
        @partners ||= profiles(partner_ids)
      end

    end

    # load children profiles
    def children(fetch = true)
      unless fetch
        # create profile from information in immediate-family response
        shallow_profiles = []
        children_ids.each do |id|
          shallow_profiles << Profile.new({:client=>client, :attrs=>@nodes["profile-#{id}"]})
        end
        return shallow_profiles
      else
        @children ||= profiles(children_ids)
      end
    end

    # load siblings profiles
    def siblings(fetch = true)
      unless fetch
        # create profile from information in immediate-family response
        shallow_profiles = []
        siblings_ids.each do |id|
          shallow_profiles << Profile.new({:client=>client, :attrs=>@nodes["profile-#{id}"]})
        end
        return shallow_profiles
      else
        @siblings ||= profiles(sibling_ids)
      end
    end


    # get ids of parent profiles, but do not load profile
    def parent_ids
      walk(focus_node, ['child', 'partner']).collect { |node| node['id'].split('-').last }
    end

    # get ids of partner profiles, but do not load profile
    def partner_ids
      walk(focus_node, ['partner', 'partner']).collect { |node| node['id'].split('-').last }
    end

    # get ids of children profiles, but do not load profile
    def children_ids
      walk(focus_node, ['partner', 'child']).collect { |node| node['id'].split('-').last }
    end

    # load ids of sibling profiles, but do not load profile
    def sibling_ids
      walk(focus_node, ['child', 'child']).collect { |node| node['id'].split('-').last }
    end


    protected

    def focus_node
      @nodes[@focus['id']]
    end

    def walk(node, rels)
      return node if rels.empty?

      node['edges'].collect do |edge_id, edge|
        if edge['rel'] == rels.first && edge_id != @focus['id']
          walk(@nodes[edge_id], rels.tail)
        end
      end.compact.flatten
    end

    def profiles(nodes)
      client.get_profile(nodes)
    end
  end
end