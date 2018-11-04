# Class: hashcat::install::ubuntu
# ===========================
# 
# This class installs hashcat on ubuntu by installing a package from a specified or default package repository
#
class hashcat::install::ubuntu(
  Variant[
    Enum['universe', 'github'],                           # Can either be 'universe',
    Struct[{                                    # or a PPA. If PPA, the following must be provided:
      ppa       => Pattern[/\Appa:.*/],         # ppa must be a string beginning with "ppa:"
      id        => Pattern[/\A[[:xdigit:]]{8}\Z|\A[[:xdigit:]]{40}\Z/],  # Id must be a hexadecimal number 8 or 40 characters long
      keyserver => Pattern[/\./]                # Key-server name must contain at least 1 dot
    }]
  ] $provider = 'github',
	$install_path = '/opt/hashcat',
) {

	case $provider {
		'github': {
			$url = $::facts["github_archive"]
			$archive_name = $::facts["github_archive_name"]

			#$install_path        = '/opt/hashcat'

			package { 'p7zip-full':
				ensure => installed,
			}

			file { $install_path: 
				ensure => 'directory',
			}

			archive { "${install_path}/${archive_name}.7z":
				source => $url,
				extract => true,
				extract_path => $install_path,
				extract_command => "7z e %s",
				creates => "${install_path}/hashcat64.bin",
				cleanup	=> false,
			}
   	}
		'universe': {
			package { 'hashcat': 
				ensure => installed
			}
		}
		default: {
			class { 'apt':
				keys   => {
  			'ppa-key' => {
    				id     => $provider['id'],
    				server => $provider['keyserver'],
  				},
				},
				ppas   => {
 		 			$provider['ppa'] => { },
				},
				update => {
					frequency => 'always',
				},
				before => Package['hashcat']
			}

			package { 'hashcat':
				ensure => installed,
			}
		}
	}
}

