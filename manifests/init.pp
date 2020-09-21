class custom_hooks (
  String $config_file,
  String $repo_path,
  String $external_url,
  String $token,
  Boolean $use_ssl,
  Boolean $verify_ssl,
) {

  $config_hash = {
    repo_path    => $repo_path,
    external_url => $external_url,
    token        => $token,
    use_ssl      => $use_ssl,
    verify_ssl   => $verify_ssl,
  }

  file { $config_file:
    ensure  => file,
    content => to_yaml($config_hash),
  }

}
