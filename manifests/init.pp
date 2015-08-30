# == Class: puppet-icinga
#
# Full description of class puppet-icinga here.
#
# === Parameters
#
# Document parameters here.
#
# [*dbtype*]
#   backend database type (mysql or pgsql)
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { puppet-icinga:
#    dbtype => 'pgsql',
#    enabled_features => ['syslog']
#  }
#
# === Authors
#
# Author Name <talamoig@roma1.infn.it>
#
# === Copyright
#
# Copyright 2015 talamoig@roma1.infn.it
#
class icinga (
  $dbtype            = $icinga::params::dbtype,
  $dbhost            = $icinga::params::dbhost,
  $dbuser            = $icinga::params::dbuser,
  $dbpasswd          = $icinga::params::dbpasswd,
  $dbname            = $icinga::params::dbname,
  $enabled_features  = $icinga::params::features,
  $disabled_features = $icinga::params::no_features,
  $with_repo         = $icinga::params::with_repo,
  $initdb            = $icinga::params::initdb,
  $with_backend      = $icinga::params::with_backend,
  $with_classicui    = $icinga::params::with_classicui,
  $with_webgui       = $icinga::params::with_webgui
  ) inherits icinga::params {
  
  class { 'icinga::repo': }

  if ($with_backend) {
    case $::operatingsystem {
      'RedHat','CentOS','Ubuntu': {
        Class[icinga::repo]      -> Class[icinga::package]
        Class[icinga::package]   -> Class[icinga::configure]
        Class[icinga::configure] -> Class[icinga::service]
        
        class { 'icinga::package': }
        class { 'icinga::service': }
        class { 'icinga::configure': }
        
      }
      default: { fail("Currently unavailable for ${::osfamily}") }
    }
  }
  if ($with_webgui) {
    case $::operatingsystem {
      'RedHat','CentOS','Ubuntu': {
        class{'icinga::webgui':}
      }
      default: { fail("Currently unavailable for ${::osfamily}") }
    }
  }
  
  if ($with_classicui) {
    case $::osfamily {
      'RedHat': {
        class{'icinga::classicui':
        }
      }
      default: { fail('Currently available only for RedHat osfamily') }
    }
  }
}
