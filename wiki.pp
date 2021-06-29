#--- Install Packages apache&php ---#

class install{
  package { 'apache2':
    ensure   => present,
    name     => 'apache2',
    provider => apt
  }
  package { 'php7.3':
    ensure   => present,
    name     => 'php7.3',
    provider => apt
  }
}

class dokuwiki{
  #--- Download dokuwiki.tgz ---#
  file { 'download-dokuwiki':
    ensure => present,
    source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
    path   => '/usr/src/dokuwiki.tgz'
  }

  #--- Extract dokuwiki.tgz ---#
  exec { 'extract-dokuwiki':
    command => 'tar xavf dokuwiki.tgz',
    cwd     => '/usr/src',
    path    => ['/usr/bin'],
    require => file['download-dokuwiki'],
    require  => file['rename-dokuwiki-2020-07-29']
  }

  #--- Rename du dossier extrait ---#
  file { 'rename-dokuwiki-2020-07-29':
    ensure => present,
    source => '/usr/src/dokuwiki-2020-07-29',
    path   => '/usr/src/dokuwiki'
  }
}

#class dokuwiki_deployment {
  #file { "create new directory for ${env}.wiki in ${web_path} and allow apache to write in":
    #ensure  => directory,
    #source  => "${source_path}/dokuwiki",
    #path    => "${web_path}/${env}.wiki",
    #recurse => true,
    #owner   => 'www-data',
    #group   => 'www-data',
    #require => File['rename-dokuwiki-2020-07-29']

class dokuwiki_deployment($env, $web_path) {
  file { "create new directory for $env.wiki in $web_path and allow apache to write in":
    ensure  => directory,
    source  => "$source_path/dokuwiki",
    path    => "$web_path/$env.wiki",
    recurse => true,
    owner   => 'www-data',
    group   => 'www-data',
    require => File['rename-dokuwiki-2020-07-29']

node 'server0' {
  include dokuwiki
  class{ deployment:
    env => 'recettes'
    web_path => 'tajineworld.com'
  }
}

node 'server1' {
  include dokuwiki
  class{ deployment:
    env => 'politique'
    web_path => 'tajineworld.com'
  }
}
