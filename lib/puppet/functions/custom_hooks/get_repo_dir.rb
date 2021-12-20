Puppet::Functions.create_function(:'custom_hooks::get_repo_dir') do
  dispatch :get_repo_dir do
    param 'String', :external_url
    param 'String', :project
    param 'String', :repo_path
    param 'String', :token
    param 'Boolean', :use_ssl
    param 'Boolean', :verify_ssl
  end

  def get_repo_dir(external_url, project, repo_path, token, use_ssl, verify_ssl)
    require 'digest'
    id = get_project_id(external_url, project, token, use_ssl, verify_ssl)
    hash = Digest::SHA256.hexdigest "#{id}"
    prefixes = hash.match(/(..)(..)/)
    repo_dir = "#{repo_path}/@hashed/#{prefixes[1]}/#{prefixes[2]}/#{hash}.git"
    repo_dir
  end

  def get_project_id(external_url, project, token, use_ssl, verify_ssl)
    require 'net/https'
    require 'json'
    require "erb"
    uri = URI.parse("#{external_url}/api/v4/projects/#{ERB::Util.url_encode(project)}")
    http = Net::HTTP.new(uri.host, uri.port)
    if use_ssl
      http.use_ssl = true
    end
    if ! verify_ssl
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(uri.request_uri, { "PRIVATE-TOKEN" => "#{token}" })
    begin
      response = http.request(request)
    rescue StandardError => e
      Puppet.err "custom_hooks::get_repo_dir: Failed to connect to GitLab external url: #{e.message}"
      return nil
    end
    json = JSON.parse(response.body)
    json['id']
  end
end
