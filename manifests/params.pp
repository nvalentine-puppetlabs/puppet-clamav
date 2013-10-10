class clamav::params {
  case $::osfamily {
    'redhat': {
      $package = 'clamav'
      $config = '/etc/freshclam.conf'
    }
    default: {fail("OS family ${::osfamily} not supported!")}
  }
}
