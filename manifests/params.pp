class tomcat::params {

  case $::osfamily {
    default: { fail("unsupported OS: ${::osfamily}") }
    'RedHat': {
      $admin_package   = [
        'tomcat6-admin-webapps',
        'tomcat6-webapps',
      ]
      $autodeploy_dir  = '/var/lib/tomcat6/webapps'
      $docs_package    = 'tomcat6-docs-webapp'
      $group           = 'tomcat'
      $service         = 'tomcat6'
      $staging_dir     = '/var/lib/tomcat6/staging'
      $tomcat_package  = 'tomcat6'
      $user            = 'tomcat'
      $user_homedir    = '/usr/share/tomcat6'
    }
    'Debian': {
      $package_specific = {
        'tomcat6' => {
          'admin_package'   => 'tomcat6-admin',
          'autodeploy_dir'  => '/var/lib/tomcat6/webapps',
          'docs_package'    => 'tomcat6-docs',
          'group'           => 'tomcat6',
          'service'         => 'tomcat6',
          'staging_dir'     => '/var/lib/tomcat6/staging',
          'tomcat_package'  => 'tomcat6',
          'user'            => 'tomcat6',
          'user_homedir'    => '/usr/share/tomcat6',
        },
        'tomcat7' => {
          'admin_package'   => 'tomcat7-admin',
          'autodeploy_dir'  => '/var/lib/tomcat7/webapps',
          'docs_package'    => 'tomcat7-docs',
          'group'           => 'tomcat7',
          'service'         => 'tomcat7',
          'staging_dir'     => '/var/lib/tomcat7/staging',
          'tomcat_package'  => 'tomcat7',
          'user'            => 'tomcat7',
          'user_homedir'    => '/usr/share/tomcat7',
        },
      }
      $admin_package   = 'tomcat6-admin'
      $autodeploy_dir  = '/var/lib/tomcat6/webapps'
      $docs_package    = 'tomcat6-docs'
      $group           = 'tomcat6'
      $service         = 'tomcat6'
      $staging_dir     = '/var/lib/tomcat6/staging'
      $tomcat_package  = 'tomcat6'
      $user            = 'tomcat6'
      $user_homedir    = '/usr/share/tomcat6'
    }
  }

}
