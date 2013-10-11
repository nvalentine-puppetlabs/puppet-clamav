class clamav(

  $scan_command = hiera('clamav::scan_command', '/usr/bin/clamscan -r -i /home /var'),
  $exclude = hiera('clamav::scan', ['/sys', '/proc']), 
  $cron_timespec = hiera('clamav::cron_timespec', '00 1 * * *'),
  $cron_mailto = hier('clamav::cron_mailto', 'root'),
  $database_mirror = hiera('clamav::database_mirror', 'db.us.clamav.net')

) inherits clamav::params {

  validate_string($scan_command)
  validate_array($exclude)
  validate_string($cron_timespec)
  validate_string($cron_mailto)
  validate_string($database_mirror)
  
  package { $package: ensure => installed, }

  file { $config: ensure => file, mode => '0644', owner => 'root', group => 'root',
    content => template("${module_name}/freshclam.conf.erb"),
    require => Package[$package],
  }

  $excludes = inline_template("<% @exclude.each do |ex| -%>--exclude=<%= ex -%><% end -%>")
  $scan_command_real = "${scan_command} ${excludes}"

  file { '/etc/cron.d/clamscan':
    ensure => file, mode => '0644', owner => 'root', group => 'root',
    content => template("${module_name}/cron.erb"),
  }
}
