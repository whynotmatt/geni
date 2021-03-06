module Geni
  class Client

    SITE              = 'https://www.geni.com'
    ACCESS_TOKEN_PATH = '/oauth/token'

    attr_reader :oauth_client, :access_token, :callback

    def initialize(params = {})

      @callback = params[:callback] ? params[:callback] : '/callback'

      @oauth_client = OAuth2::Client.new(params[:app_id], params[:app_secret],
        :site              => SITE,
        :parse_json        => true,
        :access_token_path => ACCESS_TOKEN_PATH
      )

      @access_token = OAuth2::AccessToken.new(oauth_client, params[:token])
    end

    def get_profile(id_or_ids = nil)
      get_api_results("profile",Geni::Profile, id_or_ids)
    end

    def get_family(id)
      Geni::Family.new({
        :client => self,
        :attrs  => access_token.get("/api/family-#{id}")
      })
    end

    def get_union(id_or_ids)
      get_api_results("union",Geni::Union, id_or_ids)
    end

    def get_user(id)
      Geni::User.new({
        :client => self,
        :attrs  => access_token.get("/api/user-#{id}")
      })
    end

    def get_project(id)
      Geni::Project.new({
        :client => self,
        :attrs  => access_token.get("/api/project-#{id}")
      })
    end

    def get_photo(id)
      Geni::Photo.new({
        :client => self,
        :attrs  => access_token.get("/api/photo-#{id}")
      })
    end

    def get_document(id)
      Geni::Document.new({
        :client => self,
        :attrs  => access_token.get("/api/document-#{id}")
      })
    end

    def redirect_uri(request)
      uri = URI.parse(request.url)
      uri.path = @callback
      uri.query = nil
      uri.to_s
    end

    def authorize_url(request)
      oauth_client.web_server.authorize_url({
        :redirect_uri => redirect_uri(request)
      })
    end

    def get_token(code, request)
      oauth_client.web_server.get_access_token(code, {
        :redirect_uri => redirect_uri(request)
      }).token
    end

    protected

    def get_api_results(action, return_class, id_or_ids = nil)
      if id_or_ids.nil?
        url = "/api/#{action}"
      elsif id_or_ids.kind_of?(Array)
        if id_or_ids.any?
          url = "/api/#{action}-#{id_or_ids.join(',')}"
        else
          return []
        end
      else
        url = "/api/#{action}-#{id_or_ids}"
      end

      results = access_token.get(url)
      results = results['results'] if results['results']

      profiles = [results].flatten.collect do |profile_attrs|
        return_class.new({
          :client => self,
          :attrs  => profile_attrs
        })
      end

      id_or_ids.kind_of?(Array) ? profiles : profiles.first
    end
  end
end