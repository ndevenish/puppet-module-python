define python::pip::install($package, $venv, $ensure=present) {

  # Match against whole line if we provide a given version:
  $grep_regex = $package ? {
    /==/ => "^${package}\$",
    default => "^${package}==",
  }

  if $ensure == 'present' {
    exec { "pip install $name":
      command => "$venv/bin/pip install $package",
      unless => "$venv/bin/pip freeze | grep -e $grep_regex"
    }
  } else {
    exec { "pip install $name":
      command => "$venv/bin/pip uninstall $package",
      onlyif => "$venv/bin/pip freeze | grep -e $grep_regex"
    }
  }
}
