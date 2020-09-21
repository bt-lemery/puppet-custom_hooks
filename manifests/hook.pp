define custom_hooks::hook(
  $ensure = 'present',
  $namespace,
  $project,
  $hook_type,
  $content = undef,
  $source = undef,
){

  if $ensure == 'present' {
    $d = custom_hooks::get_repo_dir($namespace, $project)

    if !defined(File["${d}/custom_hooks"]) {
      file { "${d}/custom_hooks":
        ensure => directory,
        owner  => 'git',
        group  => 'root',
        mode   => '0755',
      }
    }

    file { "${d}/custom_hooks/${hook_type}":
      ensure  => present,
      owner   => 'git',
      group   => 'root',
      mode    => '0755',
      content => $content,
      source  => $source,
    }
  } else {
    $d = custom_hooks::get_repo_dir($namespace, $project)

    file { "${d}/custom_hooks/${hook_type}":
      ensure  => absent,
    }
  }

}
