#!/usr/bin/env bash
#




SHELL_NAME=$(basename "$0")

SUCCESS_RESULT=0
TRUE=0
FAILURE_RESULT=1
FALSE=1
ROOT_UID=0

KEITARO_URL="https://keitaro.io"

WEBROOT_PATH="/var/www/keitaro"

NGINX_ROOT_PATH="/etc/nginx"
NGINX_VHOSTS_DIR="${NGINX_ROOT_PATH}/conf.d"
NGINX_KEITARO_CONF="${NGINX_VHOSTS_DIR}/vhosts.conf"

SCRIPT_NAME="${PROGRAM_NAME}.sh"
SCRIPT_URL="${KEITARO_URL}/${PROGRAM_NAME}.sh"
SCRIPT_LOG="${PROGRAM_NAME}.log"

CURRENT_COMMAND_OUTPUT_LOG="current_command.output.log"
CURRENT_COMMAND_ERROR_LOG="current_command.error.log"
CURRENT_COMMAND_SCRIPT_NAME="current_command.sh"

INDENTATION_LENGTH=2
INDENTATION_SPACES=$(printf "%${INDENTATION_LENGTH}s")

if [[ "${SHELL_NAME}" == 'bash' ]]; then
  if ! empty ${@}; then
    SCRIPT_COMMAND="curl -sSL "$SCRIPT_URL" | bash -s -- ${@}"
  else
    SCRIPT_COMMAND="curl -sSL "$SCRIPT_URL" | bash"
  fi
else
  if ! empty ${@}; then
    SCRIPT_COMMAND="${SHELL_NAME} ${@}"
  else
    SCRIPT_COMMAND="${SHELL_NAME}"
  fi
fi

declare -A VARS

RECONFIGURE_KEITARO_COMMAND_EN="curl -sSL ${KEITARO_URL}/install.sh | bash"
RECONFIGURE_KEITARO_COMMAND_RU="curl -sSL ${KEITARO_URL}/install.sh | bash -s -- -l ru"

SSL_ENABLER_ERRORS_LOG="${HOME}/.ssl_enabler_errors.log"