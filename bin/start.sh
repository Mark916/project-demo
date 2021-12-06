#!/bin/sh

source ./service_opts.sh

BINDIR=`pwd`
TMPDIR=${BINDIR}/../tmp

rm -rf ${TMPDIR}/*
# shellcheck disable=SC2068
for app in ${APPS[@]}
do
    echo Starting ${app}.........
    ${BINDIR}/start_service.sh ${app} >/dev/null 2>&1 &
    echo Start ${app} Successfully
    if [ ${app} == 'device-processor' -o ${app} == 'config_group' ];then
        waiting=0
        while [ ! -e ${TMPDIR}/${app}/${app}.lock ] && [ ${waiting} -lt 300 ]
        do
            echo "Waiting ${app} ..."
            let "waiting += 3"
            sleep 3s
        done
    else
        sleep 3s
    fi

done
