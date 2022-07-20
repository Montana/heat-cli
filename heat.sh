set -e

PROGNAME=$(heat)
VERSION="0.9.5-RC"

usage() {
    if [ "$*" != "" ] ; then
        echo "Error: $*"
        echo ""
    fi

    cat << EOF
Name:
    heat-cli $VERSION by Montana Mendy <montana@linux.com>
Usage:
    $PROGNAME [action] [id] [option ...]
Available actions:
    ac
    temp
Actions available for compute instances only:
    ac
    temp
    heat                --payload 
Options:
    -d, --payload       Payload to send with request
    -h, --help          Display this usage message and exit
    -v, --version       Prints version and exit
EOF

    exit 1
}

die() {
    echo "$PROGNAME: $*" >&2
    exit 1
}

if ! [ -x "$(command -v curl)" ]; then
    die "curl is not installed."
fi

if [ -z "$CC_KEY" ] || [ -z "$CC_HASH" ] ; then
    die "Please add CC_KEY and CC_HASH as environment variables or prepend 'CC_KEY=[...] CC_HASH=[...]'."
fi

require() {
    if [ -z "$2" ] ; then
        die "'$1' is missing."
    fi
}

checkCompute() {
    if [ "$mode" != "compute" ] ; then
        die "action only allowed with compute instances."
    fi
}

curlRequest() {
    if [ -z "$2" ] ; then
        curl -sSf \
            -H "App-Secret: $CC_KEY" \
            -H "Hash: $CC_HASH" \
            "$1"
    else
        curl -sSf \
            -H "App-Secret: $CC_KEY" \
            -H "Hash: $CC_HASH" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -X POST -d "$2" \
            "$1"
    fi
}


mode="compute"
action=""
id=""
payload=""

while [ $# -gt 0 ] ; do
    case "$1" in
    -h|--help)
        usage
        ;;
    -v|--version)
        echo "$VERSION"
        exit 1
        ;;
    -C|--compute)
        mode="compute"
        ;;
    -D|--dedicated)
        mode="dedicated"
        ;;
    -d|--payload)
        if [ -z "$2" ] ; then
          die "payload is missing."
        else
          payload="$2"
          shift
        fi
        ;;
    -*)
        usage "Unknown option '$1'"
        ;;
    *)
        if [ -z "$action" ] ; then
          action="$1"
        elif [ -z "$id" ] ; then
          id="$1"
        fi
        ;;
    esac
    shift
done


case "$action" in
    help)
        usage
        ;;
    version)
        echo "$VERSION"
        exit 1
        ;;
    boot|graphs|info|reboot|shutdown|status)
        require "id" "$id"
        curlRequest "$API_ROOT/$mode/$id/$action"
        ;;
    list)
        checkCompute
        curlRequest "$API_ROOT/$mode/list/instances"
        ;;
    list-os)
        checkCompute
        curlRequest "$API_ROOT/$mode/list/os"
        ;;
    create)
        checkCompute
        if [ -z "$payload" ] ; then
            read -p "Hostname: (Default: HOME) " input
            payload="hostname=${input:=HOME}"
            input=""
            read -p "Number of CPU Cores: (Default: 1) " input
            payload+="&cpu=${input:=1}"
            input=""
            read -p "RAM Size in MB: (Default: 512) " input
            payload+="&ram=${input:=512}"
            input=""
            read -p "Disk Size in GB: (Default: 5) " input
            payload+="&disk=${input:=5}"
            input=""
            read -p "Number of IPv4s: (Default: 1) " input
            payload+="&ips=${input:=1}"
            input=""
            echo "Loading Available OS..."
            curlRequest "$API_ROOT/$mode/list/os"
            echo ""
            read -p "Operating System Id: " input
            payload+="&os=$input"
            input=""
            read -p "Enable SSD [1|0]: (Default: 1) " input
            payload+="&ssd=${input:=1}"
            input=""
            read -p "Enable Private Networking [1|0]: (Default: 1) " input
            payload+="&pvtnet=${input:=1}"
            input=""
            read -p "Enable IPv6 [on|off]: (Default: on) " input
            payload+="&ipv6=${input:=on}"
            input=""
            read -p "Plan ID [Optional]: " input
            if ! [ -z "$input" ] ; then
              payload+="&plan=$input"
            fi
            input=""
        fi
        curlRequest "$API_ROOT/$mode/create" "$payload"
        ;;
    reinstall-os)
        checkCompute
        require "id" "$id"
        if [ -z "$payload" ] ; then
            echo "Loading Available OS..."
            curlRequest "$API_ROOT/$mode/list/os"
            echo ""
            read -p "Operating System Id: " input
            payload="os=$input"
            input=""
        fi
        curlRequest "$API_ROOT/$mode/$id/reinstall" "$payload"
        ;;
    reset-password)
        checkCompute
        require "id" "$id"
        if [ -z "$payload" ] ; then
            read -sp "New password: " input
            payload="password=$input"
            input=""
            echo ""
            read -p "Reboot now [true|false]: (Default: false) " input
            payload+="&reboot=${input:=false}"
            input=""
        fi
        curlRequest "$API_ROOT/$mode/$id/reset/pass" "$payload"
        ;;
    resize)
        checkCompute
        require "id" "$id"
        if [ -z "$payload" ] ; then
            read -p "Number of CPU Cores: (Default: 1) " input
            payload="cpu=${input:=1}"
            input=""
            read -p "RAM Size in MB: (Default: 512) " input
            payload+="&ram=${input:=512}"
            input=""
            read -p "Disk Size in GB: (Default: 5) " input
            payload+="&disk=${input:=5}"
            input=""
        fi
        curlRequest "$API_ROOT/$mode/$id/resize" "$payload"
        ;;
    *)
        usage "Please enter a valid action."
        ;;
esac
