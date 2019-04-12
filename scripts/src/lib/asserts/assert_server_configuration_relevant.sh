#!/usr/bin/env bash
#






assert_server_configuration_relevant(){
  debug 'Ensure configs has been genereated by relevant installer'
  if isset "$SKIP_CHECKS"; then
    debug "SKIP: аctual check of installer version in ${INVENTORY_FILE} disabled"
  else
    installed_version=$(detect_installed_version)
    if [[ "${RELEASE_VERSION}" == "${installed_version}" ]]; then
      debug "Configs has been generated by recent version of installer ${RELEASE_VERSION}"
    else
      if [[ "${installed_version}" == "0.9" ]]; then
        command="curl -fsSL https://keitaro.io/release-0.9/${TOOL_NAME}.sh | bash -s -- ${@}"
        run_command "${command}"
        exit
      fi
    fi
  fi
}


detect_installed_version(){
  local version=""
  if is_file_exist ${INVENTORY_FILE}; then
    version=$(grep "^installer_version=" ${INVENTORY_FILE} | sed s/^installer_version=//g)
  fi
  if empty "$version"; then
    version="0.9"
  fi
  echo "$version"
}


build_upgrade_message(){
  local installed_version="${1}"
  translate 'errors.reconfigure_keitaro' "upgrade_command='$(build_upgrade_command)'" \
    "obsolete_tool_command='$(build_obsolete_tool_command "${installed_version}")'"
  }


build_upgrade_command(){
  installer_url="https://keitaro.io/release-${RELEASE_VERSION}/install.sh"
  echo "curl ${installer_url} > run; bash run -rt upgrade,upgrade_to_${RELEASE_VERSION//\./_}"
}


build_obsolete_tool_command(){
  local installed_version="${1}"
  local obsolete_tool_name="release-${installed_version}/${TOOL_NAME}"
  echo "${SCRIPT_COMMAND/${TOOL_NAME}/${obsolete_tool_name}}"
}
