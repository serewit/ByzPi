#
# Automatically generated by blueprint(7).  Edit at your own risk.
#
class byzpi {
	Exec {
		path => '/usr/sbin:/usr/bin:/sbin:/bin',
	}
	Class['packages'] -> Class['files'] -> Class['services']
	class files {
		file {
			'/etc':
				ensure => directory;
			'/etc/avahi':
				ensure => directory;
			'/etc/avahi/avahi-daemon.conf':
				content => template('byzpi/etc/avahi/avahi-daemon.conf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/default':
				ensure => directory;
			'/etc/default/ifplugd':
				content => template('byzpi/etc/default/ifplugd'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/dnsmasq.conf':
				content => template('byzpi/etc/dnsmasq.conf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/ifplugd':
				ensure => directory;
			'/etc/ifplugd/action.d':
				ensure => directory;
			'/etc/ifplugd/action.d/mesh':
				content => template('byzpi/etc/ifplugd/action.d/mesh'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/init.d':
				ensure => directory;
			'/etc/init.d/reset_state':
				content => template('byzpi/etc/init.d/reset_state'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/init.d/ssl':
				content => template('byzpi/etc/init.d/ssl'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/olsrd':
				ensure => directory;
			'/etc/olsrd/olsrd.conf':
				content => template('byzpi/etc/olsrd/olsrd.conf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/rc.local':
				content => template('byzpi/etc/rc.local'),
				ensure  => file,
				group   => root,
				mode    => 0755,
				owner   => root;
			'/etc/resolv.conf.gateway':
				content => template('byzpi/etc/resolv.conf.gateway'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/ssl':
				ensure => directory;
			'/etc/ssl/openssl.cnf':
				content => template('byzpi/etc/ssl/openssl.cnf'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/etc/network/interfaces':
				content => template('byzpi/etc/network/interfaces'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
			'/opt/qwebirc/config.py':
				content => template('byzpi/opt/qwebirc/config.py'),
				ensure  => file,
				group   => root,
				mode    => 0644,
				owner   => root;
		}
	}
	include files
	class packages {
		exec { 'apt-get -q update':
			before => Class['apt'],
		}
		class apt {
			exec { '/bin/sh -c " { curl http://npmjs.org/install.sh || wget -O- http://npmjs.org/install.sh } | sh"':
				creates => '/usr/bin/npm',
				require => Package['nodejs'],
			}
			package {
				'apache2':
					ensure => present;
				'autoconfigd':
					ensure => present;
				'avahi-daemon':
					ensure => present;
				'avahi-discover':
					ensure => present;
				'avahi-dnsconfd':
					ensure => present;
				'avahi-utils':
					ensure => present;
				'captive-portal-daemon':
					ensure => present;
				'dhcpcd5':
					ensure => present;
				'dnsmasq':
					ensure => present;
				'firmware-linux':
					ensure => present;
				'ifplugd':
					ensure => present;
				'iputils-arping':
					ensure => present;
				'nodejs':
					ensure => present;
				'npm':
					ensure => present;
				'olsrd':
					ensure => present;
				'olsrd-plugins':
					ensure => present;
				'openssl-blacklist':
					ensure => present;
				'python-openssl':
					ensure => present;
				'python-cherrypy3':
					ensure => present;
				'python-mako':
					ensure => present;
				'python-markupsafe':
					ensure => present;
				'python-setuptools':
					ensure => present;
				'qwebirc':
					ensure => present;
				'verify-operation':
					ensure => present;
				'wireless-tools':
					ensure => present;
			}
		}
		include apt
	}
	include packages
	class services {
		class sysvinit {
			service {
				'apache2':
					enable    => true,
					ensure    => running,
					subscribe => [Package['apache2']];
				'avahi-daemon':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/avahi/avahi-daemon.conf'], Package['avahi-daemon']];
				'avahi-dnsconfd':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/avahi/avahi-daemon.conf'], Package['avahi-dnsconfd']];
				'dnsmasq':
					enable    => false,
					subscribe => [File['/etc/dnsmasq.conf'], Package['dnsmasq']];
				'ifplugd':
					enable    => true,
					ensure    => running,
					subscribe => [File['/etc/ifplugd/action.d/mesh'], File['/etc/resolv.conf.gateway'], Package['ifplugd']];
				'olsrd':
					enable    => false,
					subscribe => [File['/etc/olsrd/olsrd.conf'], Package['olsrd']];
				'qwebirc':
					enable    => true,
					ensure    => running,
					subscribe => [File['/opt/qwebirc/config.py'], Package['qwebirc']];
				'reset_state':
					enable    => true,
					ensure    => running;
			}
		}
		include sysvinit
	}
	include services
}
