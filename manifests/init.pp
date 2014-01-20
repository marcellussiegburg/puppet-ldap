# == Class: ldap
#
# Puppet module to manage client and server configuration for
# **OpenLdap**.
#
#
# === Parameters
#
#  [uri]
#    Ldap URI as a string. Multiple values can be set
#    separated by spaces ('ldap://ldapmaster ldap://ldapslave')
#    **Required**
#
#  [base]
#    Ldap base dn.
#    **Required**
#
#  [version]
#    Ldap version for the connecting client
#    *Optional* (defaults to 3)
#
#  [timelimit]
#    Time limit in seconds to use when performing searches
#    *Optional* (defaults to 30)
#
#  [bind_timelimit]
#    *Optional* (defaults to 30)
#
#  [idle_timelimit]
#    *Optional* (defaults to 30)
#
#  [binddn]
#    Default bind dn to use when performing ldap operations
#    *Optional* (defaults to false)
#
#  [bindpw]
#    Password for default bind dn
#    *Optional* (defaults to false)
#
#  [port]
#    The port which the server is using
#    *Optional* (defaults to 389 if ssl is disabled; to 636 otherwise)
#
#  [scope]
#    The scope to use
#    *Optional* (defaults to sub)
#
#  [ssl]
#    Enable TLS/SSL negotiation with the server
#    *Requires*: ssl_cert parameter
#    *Optional* (defaults to false)
#
#  [ssl_cert]
#    Filename for the CA (or self signed certificate). It should
#    be located under puppet:///files/ldap/
#    *Optional* (defaults to false)
#
#  [tls_checkpeer]
#    Require and verify server certificate.
#    *Optional* (defaults to true)
#
#  [tls_ciphers]
#    SSL cipher suite.
#    *Optional* (defaults to TLSv1)
#
#  [schema]
#    The ldap schema that should be used.
#    *Optional* (defaults to rfc2307bis)
#
#  [nsswitch]
#    If enabled (nsswitch => true) enables nsswitch to use
#    ldap as a backend for password, group and shadow databases.
#    *Requires*: https://github.com/torian/puppet-nsswitch.git (in alpha)
#    *Optional* (defaults to false)
#
#  [nss_passwd]
#    Search base for the passwd database. *base* will be appended.
#    *Optional* (defaults to false)
#
#  [nss_group]
#    Search base for the group database. *base* will be appended.
#    *Optional* (defaults to false)
#
#  [nss_shadow]
#    Search base for the shadow database. *base* will be appended.
#    *Optional* (defaults to false)
#
#  [nss_reconnect_tries]
#    Number of times to douple the sleep time
#    *Optional* (defaults to 5)
#
#  [nss_reconnect_sleeptime]
#    Initial sleep value
#    *Optional* (defaults to 4)
#
#  [nss_reconnect_maxsleeptime]
#    Max sleep value to cap at
#    *Optional* (defaults to 64)
#
#  [nss_reconnect_maxconntries]
#    How many tries before sleeping
#    *Optional* (defaults to 2)
#
#  [pam]
#    If enabled (pam => true) enables pam module, which will
#    be setup to use pam_ldap, to enable authentication.
#    *Requires*: https://github.com/torian/puppet-pam.git (in alpha)
#    *Optional* (defaults to false)
#
#  [pam_att_login]
#    User's login attribute
#    *Optional* (defaults to *'uid'*)
#
#  [pam_att_member]
#    Member attribute to use when testing user's membership
#    *Optional* (defaults to *'member'*)
#
#  [pam_passwd]
#    Password hash algorithm
#    *Optional* (defaults to *'md5'*)
#
#  [pam_filter]
#    Filter to use when retrieving user information
#    *Optional* (defaults to *'objectClass=posixAccount'*)
#
#  [sssd]
#    Enable to configure ldap via sssd.
#    Using sssd it is working on Fedora.
#    *Optional* (defaults to false)
#
#  [enable_motd]
#    Use motd to report the usage of this module.
#    *Requires*: https://github.com/torian/puppet-motd.git
#    *Optional* (defaults to false)
#
#  [ensure]
#    *Optional* (defaults to 'present')
#
#
# == Tested/Works on:
#   - Debian:    5.0   / 6.0   / 7.x
#   - RHEL       5.x   / 6.x
#   - CentOS     5.x   / 6.x
#   - OpenSuse:  11.x  / 12.x
#   - OVS:       2.1.1 / 2.1.5 / 2.2.0 / 3.0.2
#
#
# === Examples
#
# class { 'ldap':
# }
#
# class { 'ldap':
#   ensure => present,
# }
#
# === Authors
#
#  Emiliano Castagnari <ecastag@gmail.com> (a.k.a. Torian)
#  Marcellus Siegburg <msiegbur@imn.htwk-leipzig.de>
#
#
# === Copyleft
#
# Copyleft (C) 2012 Emiliano Castagnari ecastag@gmail.com (a.k.a. Torian)
# Copyleft (C) 2014 Marcellus Siegburg msiegbur@imn.htwk-leipzig.de
#
#
class ldap(
  $uri,
  $base,
  $version        = '3',
  $timelimit      = 30,
  $bind_timelimit = 30,
  $idle_timelimit = 60,
  $binddn         = false,
  $bindpw         = false,
  $port           = undef,
  $scope          = 'sub',
  $ssl            = false,
  $ssl_cert       = false,
  $tls_checkpeer  = true,
  $tls_ciphers    = 'TLSv1',
  $schema         = 'rfc2307bis',

  $nsswitch   = false,
  $nss_passwd = false,
  $nss_group  = false,
  $nss_shadow = false,
  $nss_reconnect_tries = 5,
  $nss_reconnect_sleeptime = 4,
  $nss_reconnect_maxsleeptime = 64,
  $nss_reconnect_maxconntries = 2,

  $pam            = false,
  $pam_att_login  = 'uid',
  $pam_att_member = 'member',
  $pam_passwd     = 'md5',
  $pam_filter     = 'objectClass=posixAccount',

  $sssd           = false,
  $enable_motd    = false,
  $ensure         = present) {

  include ldap::params

  if($enable_motd) {
    motd::register { 'ldap': }
  }

    include stdlib
    include ldap::params

  File {
    ensure  => $ensure,
    mode    => '0644',
    owner   => $ldap::params::owner,
    group   => $ldap::params::group,
  }
  $file_ensure = $ensure ? {
    present => directory,
    default => absent,
  }
  file { $ldap::params::prefix:
    ensure  => $file_ensure,
    require => Package[$ldap::params::package],
  }

  file { "${ldap::params::prefix}/${ldap::params::config}":
    content => template("ldap/${ldap::params::prefix}/${ldap::params::config}.erb"),
    require => File[$ldap::params::prefix],
  }

  if(!$port) {
    $port = $ssl ? {
      false => 389,
      true  => 636,
    }
  }

  if($ssl) {

    if(!$ssl_cert) {
      fail('When ssl is enabled you must define ssl_cert (filename)')
    }

    file { "${ldap::params::cacertdir}/${ssl_cert}":
      ensure => $ensure,
      owner  => 'root',
      group  => $ldap::params::group,
      mode   => '0644',
      source => "puppet:///modules/ldap/${ssl_cert}"
    }

    # Create certificate hash file
    exec { 'Build cert hash':
      command => "ln -s ${ldap::params::cacertdir}/${ssl_cert} ${ldap::params::cacertdir}/$(/usr/bin/openssl x509 -noout -hash -in ${ldap::params::cacertdir}/${ssl_cert}).0",
      unless  => "/usr/bin/test -f ${ldap::params::cacertdir}/$(/usr/bin/openssl x509 -noout -hash -in ${ldap::params::cacertdir}/${ssl_cert}).0",
      require => File["${ldap::params::cacertdir}/${ssl_cert}"]
    }
  }

  # include module nsswitch
  if($nsswitch == true) {
    include nsswitch
  }

  # include module pam
  if($pam == true) {
    include pam
  }
  if ($sssd == true) {
    class { 'sssd':
      ensure              => $ldap::ensure,
      uri                 => $ldap::uri,
      base                => $ldap::base,
      binddn              => $ldap::binddn,
      bindpw              => $ldap::bindpw,
      ssl                 => $ldap::ssl,
      tls_ciphers         => $ldap::tls_ciphers,
      cacertdir           => $ldap::ldap::params::cacertdir,
      schema              => $ldap::schema,
      nsswitch            => $ldap::nsswitch,
      nss_passwd          => $ldap::nss_passwd,
      nss_group           => $ldap::nss_group,
      nss_shadow          => $ldap::nss_shadow,
      nss_reconnect_tries => $ldap::nss_reconnect_tries,
      pam                 => $ldap::pam,
      pam_att_login       => $ldap::pam_att_login,
      pam_filter          => $ldap::pam_filter,
    }
  }
  package { $ldap::params::package :
    ensure => $ensure,
  }

}

