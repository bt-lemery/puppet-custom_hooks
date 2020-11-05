# custom_hooks::hook defined type
define custom_hooks::hook(
  String $external_url,
  String $project,
  String $repo_path,
  String $token,
  Boolean $use_ssl,
  Boolean $verify_ssl,
  Enum['update', 'post-receive', 'pre-receive'] $hook_type,
  String $ensure = 'present',
  Optional[String] $content = undef,
  Optional[String] $source = undef,
){
  if $ensure == 'present' {
    if !defined(File["${project}/custom_hooks"]) {
      file { "${project}/custom_hooks":
        ensure => directory,
        path   => Deferred('join', [[Deferred('custom_hooks::get_repo_dir',[$external_url, $project, $repo_path, $token, $use_ssl, $verify_ssl]), 'custom_hooks'], '/']), # lint:ignore:140chars
        owner  => 'git',
        group  => 'root',
        mode   => '0755',
      }
    }
    file { "${project}/custom_hooks/${hook_type}":
      ensure  => present,
      path    => Deferred('join', [[Deferred('custom_hooks::get_repo_dir', [$external_url, $project, $repo_path, $token, $use_ssl, $verify_ssl]), 'custom_hooks', $hook_type], '/']), # lint:ignore:140chars
      owner   => 'git',
      group   => 'root',
      mode    => '0755',
      content => $content,
      source  => $source,
    }
  } else {
    file { "${project}/custom_hooks/${hook_type}":
      ensure => absent,
      path   => Deferred(
        'join', [[Deferred('custom_hooks::get_repo_dir', [$external_url, $project, $repo_path, $token, $use_ssl, $verify_ssl]), 'custom_hooks', $hook_type], '/']), # lint:ignore:140chars
    }
  }
}
