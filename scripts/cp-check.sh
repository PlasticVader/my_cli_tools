#!/usr/bin/env bash

trap "self_desctruct" EXIT

function self_desctruct() {
    shred -u "$0"
}

option=${1}; shift

exec 2>/dev/null

function permissions_checker() {
    local -a documentroots=( $(grep -Proh '(?<=documentroot:\s).+' /var/cpanel/userdata/${USER}) )
    local report=${HOME}/permissions_checker_$(date +%F-%H_%M%p).txt
    for documentroot in ${documentroots[@]}
    do
        [[ -d ${documentroot} ]] && {
            find ${documentroot} -type f -exec chmod -c 644 {} \;
            find ${documentroot} -mindepth 1 -type d -exec chmod -c 755 {} \;
            [[ $documentroot =~ public_html ]] && chmod 750 $documentroot
        } || printf "%s\n" "No such directory ${documentroot}"
    done &>${report}
    unset documentroot
}

function get_inodes() {
    local dir="${1}"
    local inodes=$(find "${dir}" | wc -l)
    [[ ${inodes} =~ ^[0-9]{1,3}$ ]] && {
        return 1
    } || printf "%s" "${inodes}"
}

function inodes_and_disk_usage_checker() {
    local report=${HOME}/inodes_disk_space_check_$(date +%F-%H_%M%p).txt
    local -a dirs=( $(find ${HOME} -type d | sed -r 's/\s+/SPACE/g') )
    local -a space
    local num inodes disk_usage sorted
    for dir in ${dirs[@]}
    do
        num=$(get_inodes "${dir//SPACE/ }")
        [[ -z ${num} ]] && continue
        inodes+="${num} "${dir//SPACE/ }"\n"
    done
    unset dir
    disk_usage="$(find ${HOME} -size +500M -exec du -hs {} \;)"
    printf "[ Directories with high inode usage (more than 1000) ]\n" > $report
    printf "$( sort -nr <<< "$inodes" )" >> $report
    printf "[ Files larger than 500M ]\n" >> $report
    printf "$( sort -nr <<< "$disk_usage" )" >> $report
}

case ${option} in
    -p) permissions_checker ;;
    -u) inodes_and_disk_usage_checker ;;
     *)
        printf "Available options are: <-p/-u> (as in permission and usage)\n"
        exit 0;
esac
