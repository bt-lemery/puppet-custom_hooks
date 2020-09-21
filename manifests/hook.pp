define custom_hooks::hook(
  String $config_file = $custom_hooks::config_file,
  String $ensure = 'present',
  String $namespace,
  String $project,
  Enum['update', 'post-receive', 'pre-receive'] $hook_type,
  Optional[String] $content = undef,
  Optional[String] $source = undef,
){

  if $ensure == 'present' {

    if !defined(File['hook_path']) {
      file { 'hook_path':
        ensure => directory,
        path   => Deferred('sprintf', [ '%s/%s', Deferred('custom_hooks::get_repo_dir', [$config_file, $namespace, $project]), 'custom_hooks' ]),
        owner  => 'git',
        group  => 'root',
        mode   => '0755',
      }
    }

    file { $name:
      ensure  => present,
      path    => Deferred('sprintf', [ '%s/%s/%s', Deferred('custom_hooks::get_repo_dir', [$config_file, $namespace, $project]), 'custom_hooks', $hook_type ]),
      owner   => 'git',
      group   => 'root',
      mode    => '0755',
      content => $content,
      source  => $source,
    }

  } else {

    file { $name:
      ensure => absent,
      path    => Deferred('sprintf', [ '%s/%s/%s', Deferred('custom_hooks::get_repo_dir', [$config_file, $namespace, $project]), 'custom_hooks', $hook_type ]),
    }

  }

}
