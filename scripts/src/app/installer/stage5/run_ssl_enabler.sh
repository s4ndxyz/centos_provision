#!/usr/bin/env bash
SSL_SUCCESSFUL_DOMAINS=""
SSL_FAILED_MESSAGE=""
SSL_RERUN_COMMAND=""
SSL_OUTPUT_LOG="enable-ssl.output.log"
SSL_SCRIPT_URL="https://keitaro.io/enable-ssl.sh"

run_ssl_enabler(){
  if [[ "${VARS['ssl_certificate']}" == 'letsencrypt' ]]; then
    local options="-a"                                  # accept LE license agreement
    options="${options} -l ${UI_LANG}"                  # set language
    if [[ "${VARS['ssl_email']}" ]]; then
      options="${options} -e ${VARS['ssl_email']}"
    else
      options="${options} -w"
    fi
    local domains="${VARS['ssl_domains']//,/ }"
    local command="curl -sSL ${SSL_SCRIPT_URL} | bash -s -- ${options} ${domains}"
    message="$(translate 'messages.enabling_ssl')"
    > ${SSL_OUTPUT_LOG}
    run_command "${command}" "${message}" "hide_output" "" "" "" "${SSL_OUTPUT_LOG}"
    SSL_SUCCESSFUL_DOMAINS="$(extract_domains_from_enable_ssl_log ^OK)"
    local failed_domains="$(extract_domains_from_enable_ssl_log ^NOK)"
    SSL_FAILED_MESSAGE="$(get_message_from_enable_ssl_log ^NOK)"
    SSL_FAILED_MESSAGE="${SSL_FAILED_MESSAGE/NOK. /}"
    SSL_RERUN_COMMAND="curl -sSL ${SSL_SCRIPT_URL} | bash -s -- ${options} ${failed_domains}"
    rm -f "${SSL_OUTPUT_LOG}"
  fi
}


remove_ansi_colors(){
  sed -r "s/\x1B\[(([0-9]+)(;[0-9]+)*)?[m,K,H,f,J]//g"
}


get_message_from_enable_ssl_log(){
  local prefix="${1}"
  if is_exists_file "${SSL_OUTPUT_LOG}" "no"; then
    cat "${SSL_OUTPUT_LOG}" \
      | remove_ansi_colors \
      | grep -E "${prefix}" || :
    fi
  }


extract_domains_from_enable_ssl_log(){
  local prefix="${1}"
  get_message_from_enable_ssl_log "$prefix" \
    | sed -e 's/.*: //g' -e 's/,//'     # extract domains list from message
  }
