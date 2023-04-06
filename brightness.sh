#!/bin/bash

brightness() {
	usage() {
		cat <<EOD
Usage: $(basename "$BASH_SOURCE") [OPTIONS]

Options:
  --up                  Increase brightness.
  --down                Decrease brightness.

Increases or decreases screen brightness.
EOD
	}

	declare -A ARGS=(
		[up]=
		[down]=
	)

	# include pargs
	. "$(dirname "$BASH_SOURCE")/script-util/pargs.sh"

	local showusage=-1
	if pargs usage "$@"; then
		mapfile -s 1 -t args <<< "${ARGS[_]}"
		set -- "${args[@]}" && unset args ARGS[_]
	else
		[[ $? -eq 255 ]] && showusage=0 || showusage=$?
	fi

	if [[ $showusage -ne -1 ]]; then
		usage
		return $showusage
	fi

	local actual=$(cat /sys/class/backlight/acpi_video0/actual_brightness)
	local maximum=$(cat /sys/class/backlight/acpi_video0/max_brightness)
	local setting=$actual

	if [[ "${ARGS[up]}" ]]; then
		setting=$(( $actual + 1))
		# increment
	fi

	if [[ "${ARGS[down]}" ]]; then
		setting=$(( $actual - 1 ))
		# decrement
	fi

	if [[ $setting -gt 0 && $setting -lt $maximum ]]; then
		echo $setting > /sys/class/backlight/acpi_video0/brightness
	fi
}
brightness "$@"
