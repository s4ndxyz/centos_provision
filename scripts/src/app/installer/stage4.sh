#!/usr/bin/env bash
#





stage4(){
  debug "Starting stage 4: generate inventory file"
  if isset "$AUTO_INSTALL"; then
    debug "Skip reading vars from stdin"
  else
    if isset "${VARS['rhel_version']}" && [ "${VARS['rhel_version']}" == "8" ]; then
      install_package iptables
    fi  
    get_user_vars
  fi
  write_inventory_file
}
