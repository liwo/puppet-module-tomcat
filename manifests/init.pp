class tomcat (
  $version = 'present',
  $package = $tomcat::params::tomcat_package,
) inherits tomcat::params {
  include java

  $admin_package   = $tomcat::params::package_specific[$package]['admin_package']
  $autodeploy_dir  = $tomcat::params::package_specific[$package]['autodeploy_dir']
  $docs_package    = $tomcat::params::package_specific[$package]['docs_package']
  $group           = $tomcat::params::package_specific[$package]['group']
  $service         = $tomcat::params::package_specific[$package]['service']
  $staging_dir     = $tomcat::params::package_specific[$package]['staging_dir']
  $tomcat_package  = $tomcat::params::package_specific[$package]['tomcat_package']
  $user            = $tomcat::params::package_specific[$package]['user']
  $user_homedir    = $tomcat::params::package_specific[$package]['user_homedir']

  package { 'tomcat':
    ensure => $version,
    name   => $tomcat_package,
    before => Service['tomcat'],
  }

  service { 'tomcat':
    ensure => running,
    enable => true,
    name   => $service,
  }

  file { $autodeploy_dir:
    ensure  => directory,
  }
  file { $staging_dir:
    ensure  => directory,
  }

}
