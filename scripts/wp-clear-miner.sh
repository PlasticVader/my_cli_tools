#!/usr/bin/env bash

trap "self_desctruct" EXIT

function self_desctruct() {
    shred -u "$0"
}

KEYWORD_DOMAIN="${1}"

[[ -z $KEYWORD_DOMAIN ]] && {
    printf "Can't start without a keyword domain used in the infected files!\n"
    exit 1
}

typeset -A summary
REPORT_FILE="$HOME/wp-miner-report-$(date +%F_h-%Hm-%Ms-%Sn-%N).txt"

function back_it_up() {
    local stamp=$(date +%N) 
    local op=${1}
    local backup=${op%.php}_${stamp} 
    cat "${op}" > "${backup}" && chmod 600 "${backup}"
    summary+=( [${op}]="${backup}" ) 
}

function clear_inserted_code() {
    local opt=${1}; shift 
    back_it_up "${1}" 
    case ${opt} in
        functions_php)
            local -A patterns=(
                [format]='s/\n/NEWLINE/g; s/\s/SPACE/g'
                [remove]='s/<\?php.+?'"${KEYWORD_DOMAIN%.*}"'.+?extract.+?tmpcontent.+?\?>//; s/NEWLINE/\n/g; s/SPACE/ /g'
            )
            local contents="$(perl -pe "${patterns[format]}" "${1}" | perl -pe "${patterns[remove]}")"
            cat <<<"${contents}" > "${1}"
        ;;
        includes)
            cat /dev/null > "${1}"
        ;;
    esac
}

function functions_php_clear() {
    local -a files=( $(grep -rl "$KEYWORD_DOMAIN" ${1%includes}content/themes/) )
    for file in ${files[@]}
    do
        [[ ${file} =~ _[0-9]{9} ]] && continue 
        clear_inserted_code "functions_php" "${file}"
    done

}

function clear_miner() {
    local dir=${1} 
    local pattern="put_contents.*?ABSPATH.*?\'\K.+?(?=\')" 
    local -a inf_files=( $(grep -rl "$KEYWORD_DOMAIN" ${dir}) ) 
    for inf_file in ${inf_files[@]}
    do
        [[ ${inf_file} =~ _[0-9]{9} ]] && continue 
        local lead=$(grep -Po "${pattern}" ${inf_file})
        local inf_file_aux="${dir%/wp-includes}${lead}"
        perl -pi -e 's/(?<=\$themes\s=\s)(.*?);/exit;/' "${inf_file}"
        clear_inserted_code "includes" "${inf_file}"
        [[ -f ${inf_file_aux} ]] && clear_inserted_code "includes" "${inf_file_aux}"
    done
    functions_php_clear "${dir}"
}

function check_wp() {
    local user=${1} 
    local -a wp_includes=( $(find $HOME -type d -name wp-includes) ) 
    for wp_dir in ${wp_includes[@]}
    do
        clear_miner "${wp_dir}"
    done
    printf "cPanel user [ %s ]\n\tFiles changed:\n\n" "${user}" > "${REPORT_FILE}"
    for orig in ${!summary[@]}
    do
        printf "Backup: %s\nCurrent: %s\n\n" "${summary[$orig]}" "${orig}" >> "${REPORT_FILE}"
    done
    cat "${REPORT_FILE}"
}

check_wp $(whoami)
