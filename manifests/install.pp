# Class: hashcat::install::ubuntu
# ===========================
# 
# Installs hashcat. Calls different subclasses depending on OS.
#
class hashcat::install(
  Variant[Enum['universe', 'github'],Struct[{ppa => String, id => String, keyserver => String}]] $provider = 'github',
	$install_path = '/opt/hashcat',
) {
  if $::facts['os']['name'] == 'Ubuntu' {
    class { 'hashcat::install::ubuntu':
      provider => $provider,
			install_path => $install_path,
    }
  }
  elsif $::facts['os']['name'] == 'windows' {
    include hashcat::install::windows
  }
}
