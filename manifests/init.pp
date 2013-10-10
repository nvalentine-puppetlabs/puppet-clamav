class clamav(
  $cron_options = hiera('clamav::cron_options', {}),
  $database_mirror = hiera('clamav::database_mirror', 'db.us.clamav.net')
) inherits clamav::params {

  package { $package: ensure => installed, }

  file { $config:
    ensure => file,
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template("${module_name}/freshclam.conf.erb"),
    require => Package[$package],
  }

  if $cron_options {
    validate_hash($cron_options)
    $cron_defaults = { user => 'root', ensure => 'present', }
    create_resources('cron', $cron_options, $cron_defaults)
  }
}
