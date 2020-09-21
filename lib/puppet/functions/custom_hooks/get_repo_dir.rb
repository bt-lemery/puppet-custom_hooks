Puppet::Functions.create_function(:'custom_hooks::get_repo_dir') do
  dispatch :get_repo_dir do
    param 'String', :namespace
    param 'String', :project
  end

  def get_repo_dir(namespace, project)
    require 'digest'
    config = get_config
    id = get_project_id(config, namespace, project)
    hash = Digest::SHA256.hexdigest "#{id}"
    prefixes = hash.match(/(..)(..)/)
    repo_dir = config['repo_path'] + '/@hashed/' + prefixes[1] + '/' + prefixes[2] + '/' + hash + '.git'
    repo_dir
  end

  def get_config
    require 'yaml'
    config = YAML.load_file('/etc/custom_hooks.yaml')
    config
  end

  def get_project_id(config, namespace, project)
    # require 'net/http'
    require 'net/https'
    require 'json'
    url = config['external_url'] + '/api/v4/projects/' + namespace + "%2F" + project
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if config['use_ssl']
      http.use_ssl = true
    end
    if ! config['verify_ssl']
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    headers = { "PRIVATE-TOKEN" => "#{config['token']}" }
    request = Net::HTTP::Get.new(uri.request_uri, headers)
    response = http.request(request)
    body = response.body
    json = JSON.parse(body)
    json['id']
  end
end
