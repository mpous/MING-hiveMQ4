#!/usr/bin/env bash

set -eo pipefail

if [[ "${HIVEMQ_VERBOSE_ENTRYPOINT}" == "true" ]]; then
    exec 3>&1
    set -o xtrace
else
    exec 3>/dev/null
fi

# balena gets the license file if there is the $LICENSE_TOKEN DEVICE_VARIABLE defined
# Run entrypoint parts
for f in $(find "/docker-entrypoint.d/" -follow -type f -print | sort -V); do
  if [ -x "$f" ]; then
    echo >&3 "$0: running $f"
    "$f"
  else
    echo >&3 "$0: sourcing $f"
    . "$f"
  fi
done

${exec_cmd} "$@"