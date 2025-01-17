#!/bin/bash
set +x
CURRENT_PATH=$(dirname $(readlink -f $0))
CANTIAN_CONFIG_PATH="/mnt/dbdata/local/cantian/tmp/data/dbstor/conf/dbs"
DBSTOR_CONFIG_PATH="/opt/cantian/dbstor/tools/dbstor_config.ini"
DBSTOR_CONFIG_NAME="dbstor_config.ini"
DORADO_CONF_PATH="${CURRENT_PATH}/../../config/container_conf/dorado_conf"
DBSTOR_USER="dbstorUser"
DBSTOR_PWD="dbstorPwd"
CANTIAN_VLAN_NAME=("net1" "net2")

function set_dbstor_config() {
    storage_dbstore_fs=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "storage_dbstore_fs"`
    storage_dbstore_page_fs=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "storage_dbstore_page_fs"`
    link_type=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "link_type"`
    node_id=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "node_id"`
    cluster_id=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "cluster_id"`
    
    cantian_vlan_ip=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "cantian_vlan_ip"`
    #for vlan_name in "${CANTIAN_VLAN_NAME[@]}"
    #do
    #    if [ -z "${cantian_vlan_ip}" ]; then
    #        cantian_vlan_ip=`ip add show dev ${vlan_name} | grep -w 'inet' | awk '{print $2}' | awk -F '/' '{print $1}'`
    #    else
    #        cantian_vlan_ip_tmp=`ip add show dev ${vlan_name} | grep -w 'inet' | awk '{print $2}' | awk -F '/' '{print $1}'`
    #        if [ ! -z ${cantian_vlan_ip_tmp} ]; then
    #            cantian_vlan_ip="${cantian_vlan_ip};${cantian_vlan_ip_tmp}"
    #        fi
    #    fi
    #done

    storage_vlan_ip=`python3 ${CURRENT_PATH}/../cantian/get_config_info.py "storage_vlan_ip"`
    dpu_uuid=`uuidgen`
    dbstor_user=`cat ${DORADO_CONF_PATH}/${DBSTOR_USER}`
    dbstor_pwd=`cat ${DORADO_CONF_PATH}/${DBSTOR_PWD}`

    sed -i -r "s:(NAMESPACE_FSNAME = ).*:\1${storage_dbstore_fs}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(NAMESPACE_PAGE_FSNAME = ).*:\1${storage_dbstore_page_fs}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(DPU_UUID = ).*:\1${dpu_uuid}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(LINK_TYPE = ).*:\1${link_type}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(LOCAL_IP = ).*:\1${cantian_vlan_ip}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(REMOTE_IP = ).*:\1${storage_vlan_ip}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(USER_NAME = ).*:\1${dbstor_user}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(PASSWORD = ).*:\1${dbstor_pwd}:g" ${DBSTOR_CONFIG_PATH}
    sed -i -r "s:(CLUSTER_ID = ).*:\1${cluster_id}:g" ${DBSTOR_CONFIG_PATH}
}

function cantian_copy_dbstor_config() {
    if [ -f ${CANTIAN_CONFIG_PATH}/${DBSTOR_CONFIG_NAME} ]; then
        rm -rf ${CANTIAN_CONFIG_PATH}/${DBSTOR_CONFIG_NAME}
    fi
    cp -arf ${DBSTOR_CONFIG_PATH} ${CANTIAN_CONFIG_PATH}/${DBSTOR_CONFIG_NAME}
    sed -i -r "s:(DBSTOR_OWNER_NAME = ).*:\1cantian:g" ${CANTIAN_CONFIG_PATH}/${DBSTOR_CONFIG_NAME}
}

set_dbstor_config
cantian_copy_dbstor_config