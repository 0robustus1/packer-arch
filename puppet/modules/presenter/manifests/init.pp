class presenter {
  # class { 'pacman':
  #   enable_aur => true,
  # }

  # Install Display Manager
  package { "lightdm":
    ensure => "installed"
  }

  package { "lightdm-gtk-greeter":
    ensure => "installed"
  }

  # Install fluxbox
  package { "fluxbox":
    ensure => "installed"
  }

  # Install gnome
  package { "gnome":
    ensure => "installed"
  }

  # AUR necessities
  package { "base-devel":
    ensure => "installed"
  }

  user { 'auruser':
    ensure     => 'present',
    managehome => true
  }

  sudo::sudoers { 'auruser':
    ensure   => 'present',
    users    => [ 'auruser' ],
    runas    => [ 'root' ],
    cmnds    => [ 'ALL' ],
    tags     => [ 'NOPASSWD' ],
    defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
  }

  exec { "register_lightdm":
    command => "systemctl enable lightdm",
    path    => ["/usr/local/bin", "/usr/bin", "/bin"]
  }

  include 'pacman::yaourt'
  pacman::aur { 'pdfpc':
    ensure => 'present'
  }
}
