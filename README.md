# custom_hooks

Puppet module for Gitlab custom hooks.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with custom_hooks](#setup)
    * [What custom_hooks affects](#what-custom_hooks-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with custom_hooks](#beginning-with-custom_hooks)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module uses a local config file and the puppet Deferred function to create custom hooks on your Gitlab repos when using hashed storage.

## Setup

### Setup Requirements

This module makes use of the Puppet 6 Deferred function. It is therefore *only* compatible with Puppet 6+.

This module relies on the to_yaml function of the stdlib module.

This module requires a valid Gitlab access token with read_api access https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html

### Beginning with custom_hooks

Add the following class declaration and any custom_hook::hook defined type resources to your gitaly nodes:

```
class { '::custom_hooks':
  config_file  => '/root/gitfig.yaml',
  repo_path    => '/var/opt/gitlab/git-data/repositories',
  external_url => 'https://gitlab.auto.saas-n.com',
  token        => '<seekrit token>',
  use_ssl      => true,
  verify_ssl   => false,
}
```

The main class sets up the config file that the get_repo_dir function reads to determine where it will create your 'custom_hook' directories.

You can declare you custom hooks like so.  Substitute 'content' for 'source' below if you need a template.

```
custom_hooks::hook { 'foo':
  ensure    => present,
  project   => 'lemery/test-project',
  hook_type => 'pre-receive',
  source    => "file:///root/test.sh",
  require   => Class['custom_hooks'],
}
```

Declare your hook with `ensure => absent` and they will be removed.

## Usage

As above.

## Reference

This section is deprecated.

## Limitations

Requires Puppet 6+

## Development

There are always bugs.  Pull requests very welcome.

