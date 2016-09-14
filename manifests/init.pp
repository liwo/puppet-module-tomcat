class tomcat (
  $version = 'present',
  $package = $tomcat::params::tomcat_package,
  $port = $tomcat::params::port,
  $ssl_port = $tomcat::params::ssl_port,
  $connector_options = undef,
  $java_opts = undef,
  $xms = undef,
  $xmx = '128m',
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
  $java_home = regsubst($java::use_java_alternative_path, 'bin/java$', '')

  package { 'tomcat':
    ensure => $version,
    name   => $tomcat_package,
    before => Service['tomcat'],
  }

	# Fix tomcat service not starting after package installation on oracle java
	if $::lsbdistcodename == 'xenial' and $::java::distribution =~ 'oracle' {
		include ::systemd

		file { "/etc/systemd/system/${service}.service.d":
			ensure => 'directory',
			owner => 'root',
			group => 'root',
			mode => '0644',
			before => Package['tomcat'],
		}
		file { "/etc/systemd/system/${service}.service.d/java-home.conf":
			ensure => 'file',
			owner => 'root',
			group => 'root',
			mode => '0644',
			content => "[Service]
# Fix service not starting with oracle java
Environment=JAVA_HOME=${java_home}
",
			before => Package['tomcat'],
			notify => Exec['systemctl-daemon-reload'],
		}
		Exec['systemctl-daemon-reload'] -> Package['tomcat']
	}

  if $::osfamily == 'Debian' and $package in ['tomcat7', 'tomcat8'] {
    augeas { "tomcat7-java7-setup":
      context => "/files/etc/default/$package",
      changes => [
        "set JAVA_HOME $java_home",
      ],
      require => Package['tomcat'],
      notify => Service['tomcat'],
    }
  }

  if $port < 1024 {
    $authbind = 'yes'
  } else {
    $authbind = 'no'
  }
  augeas { "tomcat-authbind":
    context => "/files/etc/default/$package",
    changes => [
      "set AUTHBIND $authbind",
    ],
    require => Package['tomcat'],
    notify => Service['tomcat'],
  }

  $java_opts_xmx = $xmx ? {
    undef => '',
    default => "-Xmx$xmx",
  }
  $java_opts_xms = $xms ? {
    undef => '',
    default => "-Xms$xms",
  }
  $java_opts_line = "-Djava.awt.headless=true -XX:+UseConcMarkSweepGC $java_opts_xmx $java_opts_xms $java_opts"

  augeas { "tomcat-java_opts":
    context => "/files/etc/default/$package",
    changes => [
      "set JAVA_OPTS '\"$java_opts_line\"'",
    ],
    require => Package['tomcat'],
    notify => Service['tomcat'],
  }


  file { "/etc/$package/server.xml":
    content => template('tomcat/server.xml.erb'),
    require => Package['tomcat'],
    notify => Service['tomcat'],
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
