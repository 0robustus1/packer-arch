class hets {

  package { "ghc":
    ensure => "installed"
  }

  package { "cabal-install":
    ensure => "installed"
  }

  package { "git":
    ensure => "installed"
  }

  user { "auruser":
    ensure     => "present",
    managehome => true
  }

  sudo::sudoers { "auruser":
    ensure   => "present",
    users    => [ "auruser" ],
    runas    => [ "root" ],
    cmnds    => [ "ALL" ],
    tags     => [ "NOPASSWD" ],
    defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
  }

  include "pacman::yaourt"

  pacman::aur { "cairo":
    ensure => "present"
  }

  pacman::aur { "fontconfig":
    ensure => "present"
  }

  pacman::aur { "gettext":
    ensure => "present"
  }

  pacman::aur { "glib2":
    ensure => "present"
  }

  pacman::aur { "gtk2":
    ensure => "present"
  }

  pacman::aur { "hets-lib":
    ensure => "present"
  }

  pacman::aur { "libglade":
    ensure => "present"
  }

  pacman::aur { "ncurses":
    ensure => "present"
  }

  pacman::aur { "pellet":
    ensure => "present"
  }

  pacman::aur { "spass":
    ensure => "present"
  }

  pacman::aur { "tcl":
    ensure => "present"
  }

  pacman::aur { "tk":
    ensure => "present"
  }

  pacman::aur { "udrawgraph":
    ensure => "present"
  }

  user { "hets":
    ensure     => "present",
    managehome => true
  }

  sudo::sudoers { "hets":
    ensure   => "present",
    users    => [ "hets" ],
    runas    => [ "root" ],
    cmnds    => [ "ALL" ],
    tags     => [ "NOPASSWD" ],
    defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
  }

  exec { "hets-dependencies":
    user    => "hets",
    cwd     => "/tmp",
    command => "cabal update && cabal install aterm random utf8-string xml fgl HTTP haskeline HaXml hexpat uni-uDrawGraph parsec1 wai-extra warp http://www.informatik.uni-bremen.de/agbkb/forschung/formal_methods/CoFI/hets/src-distribution/programatica-1.0.0.5.tar.gz tar",
    path    => ["/usr/local/bin", "/usr/bin", "/bin"]
  }
}
