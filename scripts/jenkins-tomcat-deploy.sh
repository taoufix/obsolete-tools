#!/bin/bash

export LC_ALL=C

function info {
        echo "[INFO] [$(date)] $@"
}

function err {
        >&2 echo "[ERROR] [$(date)] $@"
}

R_TOMCAT="tomcat"

while getopts ":h:t:c:" opt; do
        case $opt in
                h)
                        R_HOSTNAME="${OPTARG}"
                        ;;
                c)
                        R_TARGET_WAR="${OPTARG}.war"
                        ;;
                t)
                        R_TOMCAT="${OPTARG}"
                        ;;
                \?)
                        err "Invalid option: -$OPTARG"
                        exit 1
                        ;;
                :)
                        err "Option -$OPTARG requires an argument."
                        exit 1
                        ;;
        esac
done

info "#####################################################################################"
info "Starting deployment for Job [${JOB_NAME}] in workspace [${WORKSPACE}] with args [${@}]"

if [[ -z "$R_HOSTNAME" ]]; then
        err "Usage $0 -h HOST_NAME [-c WEBAPP_CONTEXT] [-t TOMCAT_ID]"
        exit 1
fi

R_USER="root"
R_DEPLOY_LOCATION="/usr/local/pjee/${R_TOMCAT}/webapps"

## FIND WAR
WAR=`find "${WORKSPACE}" -name '*.war'`
if (( $? == 0)); then
        info "War file located at [${WAR}]"
else
        err "Error while trying to find war file."
        exit 2
fi

## STOP TOMCAT
info "Stopping remote [${R_TOMCAT}] ..."
ssh ${R_USER}@${R_HOSTNAME} "/etc/init.d/${R_TOMCAT} stop"
if (( $? == 0)); then
        info "Tomcat [${R_TOMCAT}] stopped successfully."
else
        err "Failed to stop [${R_TOMCAT}]!"
        exit 1
fi

## WAIT FOR TOMCAT TO SHUTDOWN
sleep 35 # Wait 35sec

## DEPLOY WAR
R_TARGET="${R_HOSTNAME}:${R_DEPLOY_LOCATION}"
if [[ ! -z "${R_TARGET_WAR}" ]]; then
        R_TARGET="${R_TARGET}/${R_TARGET_WAR}"
fi
info "Deplying war file to [${R_TARGET}]..."
scp -q "${WAR}" "${R_USER}@${R_TARGET}"
if (( $? == 0)); then
        info "War deployed successfully."
else
        err "Failed to deploy war file."
        exit 3
fi

## START TOMCAT
info "Starting remote [${R_TOMCAT}]..."
ssh ${R_USER}@${R_HOSTNAME} "chown tomcat:tomcat ${R_DEPLOY_LOCATION}/*.war; /etc/init.d/${R_TOMCAT} start"
if (( $? == 0)); then
        info "Tomcat [${R_TOMCAT}] started successfully."
else
        err "Failed to start [${R_TOMCAT}]!"
        exit 1
fi

info "Job [${JOB_NAME}] Deplyement ended successfully."
info "#####################################################################################"
echo
echo
exit 0

tomcat@VSLPICS1DV024:~/bin> cat tomcat-remote-deploy.sh
#!/bin/bash

export LC_ALL=C

function info {
        echo "[INFO] [$(date)] $@"
}

function err {
        >&2 echo "[ERROR] [$(date)] $@"
}

R_TOMCAT="tomcat"

while getopts ":h:t:c:" opt; do
        case $opt in
                h)
                        R_HOSTNAME="${OPTARG}"
                        ;;
                c)
                        R_TARGET_WAR="${OPTARG}.war"
                        ;;
                t)
                        R_TOMCAT="${OPTARG}"
                        ;;
                \?)
                        err "Invalid option: -$OPTARG"
                        exit 1
                        ;;
                :)
                        err "Option -$OPTARG requires an argument."
                        exit 1
                        ;;
        esac
done

info "#####################################################################################"
info "Starting deployment for Job [${JOB_NAME}] in workspace [${WORKSPACE}] with args [${@}]"

if [[ -z "$R_HOSTNAME" ]]; then
        err "Usage $0 -h HOST_NAME [-c WEBAPP_CONTEXT] [-t TOMCAT_ID]"
        exit 1
fi

R_USER="root"
R_DEPLOY_LOCATION="/usr/local/pjee/${R_TOMCAT}/webapps"

echo "hostname=$R_HOSTNAME tomcat=$R_TOMCAT context=$R_TARGET_WAR"
exit 0

## FIND WAR
WAR=`find "${WORKSPACE}" -name '*.war'`
if (( $? == 0)); then
        info "War file located at [${WAR}]"
else
        err "Error while trying to find war file."
        exit 2
fi

## STOP TOMCAT
info "Stopping remote [${R_TOMCAT}] ..."
ssh ${R_USER}@${R_HOSTNAME} "/etc/init.d/${R_TOMCAT} stop"
if (( $? == 0)); then
        info "Tomcat [${R_TOMCAT}] stopped successfully."
else
        err "Failed to stop [${R_TOMCAT}]!"
        exit 1
fi

## WAIT FOR TOMCAT TO SHUTDOWN
sleep 35 # Wait 35sec

## DEPLOY WAR
R_TARGET="${R_HOSTNAME}:${R_DEPLOY_LOCATION}"
if [[ ! -z "${R_TARGET_WAR}" ]]; then
        R_TARGET="${R_TARGET}/${R_TARGET_WAR}"
fi
info "Deplying war file to [${R_TARGET}]..."
scp -q "${WAR}" "${R_USER}@${R_TARGET}"
if (( $? == 0)); then
        info "War deployed successfully."
else
        err "Failed to deploy war file."
        exit 3
fi

## START TOMCAT
info "Starting remote [${R_TOMCAT}]..."
ssh ${R_USER}@${R_HOSTNAME} "chown tomcat:tomcat ${R_DEPLOY_LOCATION}/*.war; /etc/init.d/${R_TOMCAT} start"
if (( $? == 0)); then
        info "Tomcat [${R_TOMCAT}] started successfully."
else
        err "Failed to start [${R_TOMCAT}]!"
        exit 1
fi

info "Job [${JOB_NAME}] Deplyement ended successfully."
info "#####################################################################################"
echo
echo
exit 0
