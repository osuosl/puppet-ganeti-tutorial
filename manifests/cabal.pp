class ganeti_tutorial::cabal {
    exec { "update-cabal":
        command => "/usr/bin/cabal update",
        require => Package["cabal-install"],
        unless  => "/usr/bin/test -f /root/.cabal/packages/hackage.haskell.org/00-index.tar.gz";
    }
    package { "cabal-install": ensure => installed; }
}

define ganeti_tutorial::cabal::install($version="") {
    if $version { 
        exec { "cabal-$name-$version":
            command => "/usr/bin/cabal install --global ${name}-${version}",
            timeout => "300",
            require => Exec["update-cabal"],
            onlyif  => "/usr/bin/test -z \"`/usr/bin/ghc-pkg list --simple-output ${name}-${version}`\"";
        }
    } else { 
        exec { "cabal-$name":
            command => "/usr/bin/cabal install --global $name",
            timeout => "300",
            require => Exec["update-cabal"],
            onlyif  => "/usr/bin/test -z \"`/usr/bin/ghc-pkg list --simple-output $name`\"";
        }
    }
}
