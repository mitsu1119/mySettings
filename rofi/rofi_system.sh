#!/usr/bin/bash

declare -A list=(
	['Shutdown']='systemctl poweroff'
	['Reboot']='systemctl reboot'
)

function main() {
	local y='(yes)' n='(no)'

	if [[ $2 == $y ]]; then
		eval "${list[$1]}"
	elif [[ $2 == $n ]]; then
		echo "${!list[@]}" | sed 's/ /\n/g'
	elif [[ -n $1 ]]; then
		echo $1 $n
		echo $1 $y
	else
		echo "${!list[@]}" | sed 's/ /\n/g'
	fi
}

main $@
