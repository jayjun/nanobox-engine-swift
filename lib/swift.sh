# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Determine the Swift runtime to install. This will first check
# within the Boxfile, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate \
    "$(nos_payload "config_runtime")" \
    "string" "$(default_runtime)")
}

# Provide a default Swift version
default_runtime() {
  echo "swift-4.0"
}

# Install the Swift runtime
install_runtime_packages() {
  pkgs=('clang' 'icu' 'curl' 'python-2.7' "$(runtime)")

  nos_install ${pkgs[@]}
}

# Uninstall build dependencies
uninstall_build_packages() {
  pkgs=('clang')

  if [[ ${#pkgs[@]} -gt 0 ]]; then
    nos_uninstall ${pkgs[@]}
  fi
}

# Allow users to specify a custom fetch command to fetch dependencies
# fetch_cmd() {
#   echo $(nos_validate "$(nos_payload "config_fetch")" "string" )
# }

# Fetch application dependencies
fetch_deps() {
  cd $(nos_code_dir)
  nos_run_process "Fetching dependencies" "swift package fetch"
  cd - >/dev/null
}

# Allow users to specify a custom build command to compile the application
build_cmd() {
  echo $(nos_validate "$(nos_payload "config_build")" "string" "swift build --configuration release")
}

# Compile the Swift application
compile() {
  cd $(nos_code_dir)
  nos_run_process "Compiling application" "$(build_cmd)"
  cd - >/dev/null
}

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live app directory..."
  rsync -a $(nos_code_dir)/ $(nos_app_dir)
}
