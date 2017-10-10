# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# Determine the Swift runtime to install. This will first check
# within the Boxfile, then will rely on default_runtime to
# provide a sensible default
runtime() {
  echo $(nos_validate "$(nos_payload "config_runtime")" "string" "swift-4.0")
}

# Install the Swift runtime
install_runtime_packages() {
  pkgs=('clang' 'icu-55' 'curl')

  nos_install ${pkgs[@]}

  # TODO: Replace with pkgin package
  cd $(nos_data_dir)

  wget "https://swift.org/builds/$(runtime)-release/ubuntu1604/$(runtime)-RELEASE/$(runtime)-RELEASE-ubuntu16.04.tar.gz"
  mkdir -p "$(nos_data_dir)/lib/swift"
  tar xzf "$(runtime)-RELEASE-ubuntu16.04.tar.gz" -C "$(nos_data_dir)/lib/swift" --strip-components=1
  rm "$(runtime)-RELEASE-ubuntu16.04.tar.gz"

  cd bin
  ln -s ../lib/swift/usr/bin/lldb /data/bin/lldb
  ln -s ../lib/swift/usr/bin/lldb-argdumper lldb-argdumper
  ln -s ../lib/swift/usr/bin/lldb-mi lldb-mi
  ln -s ../lib/swift/usr/bin/lldb-server lldb-server
  ln -s ../lib/swift/usr/bin/lldb-server lldb-server
  ln -s ../lib/swift/usr/bin/repl_swift repl_swift
  ln -s ../lib/swift/usr/bin/swift swift
  ln -s ../lib/swift/usr/bin/swift-autolink-extract swift-autolink-extract
  ln -s ../lib/swift/usr/bin/swift-build swift-build
  ln -s ../lib/swift/usr/bin/swift-build-tool swift-build-tool
  ln -s ../lib/swift/usr/bin/swift-demangle swift-demangle
  ln -s ../lib/swift/usr/bin/swift-package swift-package
  ln -s ../lib/swift/usr/bin/swift-run swift-run
  ln -s ../lib/swift/usr/bin/swift-test swift-test
  ln -s ../lib/swift/usr/bin/swiftc swiftc

  cd - >/dev/null
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
