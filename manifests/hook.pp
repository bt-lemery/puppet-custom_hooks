# custom_hooks::hook defined type
define custom_hooks::hook(
  String $project,
  Enum['update', 'post-receive', 'pre-receive'] $hook_type,
  String $config_file = $custom_hooks::config_file,
  String $ensure = 'present',
  Optional[String] $content = undef,
  Optional[String] $source = undef,
){
  if $ensure == 'present' {
    if !defined(File["${project}/custom_hooks"]) {
      file { "${project}/custom_hooks":
        ensure => directory,
        path   => Deferred(
          'join', [[Deferred('custom_hooks::get_repo_dir', [$config_file, $project]), 'custom_hooks'], '/']
        ),
        owner  => 'git',
        group  => 'root',
        mode   => '0755',
      }
    }
    file { "${project}/custom_hooks/${hook_type}":
      ensure  => present,
      path    => Deferred(
        'join', [[Deferred('custom_hooks::get_repo_dir', [$config_file, $project]), 'custom_hooks', $hook_type], '/']
      ),
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
        'join', [[Deferred('custom_hooks::get_repo_dir', [$config_file, $project]), 'custom_hooks', $hook_type], '/']
      ),
    }
  }
}
