class icinga::repo {
  
  if $icinga::with_repo {
    case $::operatingsystem {
      'RedHat','CentOS','ScientificLinux': {
        yumrepo {'icinga-stable-release':
          baseurl  => 'http://packages.icinga.org/epel/$releasever/release/',
          enabled  => '1',
          gpgcheck => '1',
          gpgkey   => 'http://packages.icinga.org/icinga.key',
        }
      }
      'Ubuntu': {
        exec{'icinga::repo::install':
          command => '/usr/bin/add-apt-repository ppa:formorer/icinga',
          creates => '/etc/apt/sources.list.d/formorer-icinga-trusty.list',
        }
        exec{'icinga::repo::cache-update':
          command => '/usr/bin/apt-get update',
          creates => '/var/lib/apt/lists/ppa.launchpad.net_formorer_icinga_ubuntu_dists_trusty_Release',
        }
      }
      default: { fail("Currently unavailable for ${::osfamily}") }
    }
  }
}
