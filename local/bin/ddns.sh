#!/bin/env bash

# Author: Paolo Di Giglio

#
# Help aobut freemyip DDNS can be found at:
#
# https://freemyip.com/help?domain=${domain}&token=${token}
#
# Consider also using another DDNS like https://www.duckdns.org.
#

# typeset -r ddns="http://freemyip.com"
typeset -r ddns_s="https://freemyip.com"

# Perform the actual DDNS update.
#
# @param $1[str] The token.
# @param $2[str] The domain.
# @param $3[int] Whether the update sould be verbose.
function do_update_ddns() {
	typeset -r token="$1"
	typeset -r domain="$2"
	typeset -ir verbose="$3"

	typeset verbose_opt=""
	if ((verbose != 0)); then
		verbose_opt="&verbose=yes"
	fi

	typeset -r url="$ddns_s/update?token=${token}&domain=${domain}${verbose_opt}"
	curl --silent "$url"
}

# Check if a string is a plausible IPv4 address.
#
# @param $1[str] The string to check.
function is_ipv4() {
	typeset -r ip="$1"

	# TODO: I may also each value is <= 255 but it's good enough for now.
	[[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

# Resolve a domain to an IP address.
#
# @param $1[str] The domain.
function resolve_domain() {
	typeset -r domain="$1"

	typeset domain_ip=""
	domain_ip="$(dig +short "$domain")" &&
		is_ipv4 "$domain_ip" &&
		echo "$domain_ip"
}

# Get my current IPv4 address.
function get_my_ipv4() {
	# curl --silent "$ddns/checkip"

	typeset domain_ip=""
	domain_ip="$(dig +short myip.opendns.com @resolver1.opendns.com)" &&
		is_ipv4 "$domain_ip" &&
		echo "$domain_ip"
}

# Validate parameters and update the DDNS, if needed (or forced).
#
# @param $1[str] The token.
# @param $2[str] The domain.
# @param $3[int] Whether the update sould be verbose.
# @param $4[int] Whether to force update.
function update_ddns() {
	typeset -r token="$1"
	typeset -r domain="$2"
	if [ -z "$token" ] || [ -z "$domain" ]; then
		(
			echo "Missing '-t <token>' or '-d <domain>'"
			echo ""
			usage
		) >/dev/stderr
		return 1
	fi

	typeset current_ip=""
	if ! current_ip="$(get_my_ipv4)"; then
		echo "Can't find current IPv4 address." >/dev/stderr
		return 1
	else
		echo "Current IP is: $current_ip."
	fi

	typeset domain_ip=""
	if ! domain_ip="$(resolve_domain "$domain")"; then
		echo "Can't resolve IPv4 for '$domain' ." >/dev/stderr
		return 1
	fi

	typeset -ir force="$4"
	if ((force != 0)) || [ "$domain_ip" != "$current_ip" ]; then
		typeset -ir verbose="$3"
		do_update_ddns "$token" "$domain" "$verbose"
	else
		echo "IP did not change.  Nothing to do."
	fi
}

function usage() {
	cat <<EOF
USAGE: $0 [[opts...]]

OPTIONS:
 -c Get current public IP (check).  This is the default.
    Mutually exclusive with -u.

 -u Update the DDNS with the current IP.  Requires -d and -t.
    See below.

    -d <domain> The domain name on the DDNS service.

    -t <token>  The token on the DDNS service.

    -f          Force update even if IP did not change.

    -v          Verbose output (from domain update).

 -h Show this help and exit.
EOF
}

function main() {
	typeset -i check=0
	typeset -i update=0
	typeset -i force=0

	typeset token=""
	typeset domain=""
	typeset -i verbose=0

	local OPTIND OPTARG o
	while getopts "hcvufd:t:" o; do
		case "$o" in
		c)
			check=1
			;;

		v)
			verbose=1
			;;

		f)
			force=1
			;;

		d)
			domain="$OPTARG"
			;;

		t)
			token="$OPTARG"
			;;

		u)
			update=1
			;;

		h)
			usage
			return 0
			;;

		*)
			usage
			return 1
			;;
		esac
	done

	if ((check != 0)) || ((check == 0 && update == 0)); then
		get_my_ipv4
	elif ((update != 0)); then
		update_ddns "$token" "$domain" "$verbose" "$force"
	fi
}

main "$@"
