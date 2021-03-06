#!/usr/bin/env bash
PROVISION_DIRECTORY="centos_provision-${BRANCH}"
KEITARO_ALREADY_INSTALLED_RESULT=2
PHP_ENGINE=${PHP_ENGINE:-roadrunner}
DETECTED_PREFIX_PATH=".keitaro/detected_prefix"

LICENSE_EDITION_TYPE_TRIAL="trial"
LICENSE_EDITION_TYPE_COMMERCIAL="commercial"
LICENSE_EDITION_TYPE_INVALID="INVALID"
LICENSE_EDITION_TYPES=("$LICENSE_EDITION_TYPE_TRIAL" "$LICENSE_EDITION_TYPE_COMMERCIAL" "$LICENSE_EDITION_TYPE_INVALID")

DETECTED_LICENSE_EDITION_TYPE=""
