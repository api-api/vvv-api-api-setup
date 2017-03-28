#!/usr/bin/env bash

DOMAIN=`get_primary_host "${VVV_SITE_NAME}".dev`
DOMAINS=`get_hosts "${DOMAIN}"`

REPO_NAMES=(
  authenticator-basic
  authenticator-bearer
  authenticator-oauth1
  authenticator-x
  authenticator-x-account
  boilerplate-for-authenticator
  boilerplate-for-storage
  boilerplate-for-structure
  boilerplate-for-transporter
  core
  console
  storage-cookie
  storage-session
  storage-wordpress-option
  storage-wordpress-usermeta
  structure-billomat
  structure-google
  structure-twitter
  structure-wordpress
  transporter-curl
  transporter-requests
  transporter-wordpress
)

CUSTOM_REPO_NAMES=(`cat ${VVV_CONFIG} | shyaml get-values sites.${SITE_ESCAPED}.custom.repo_names 2> /dev/null`)

for i in "${REPO_NAMES[@]}"
do :
  if [[ ! -d "${VVV_PATH_TO_SITE}/public_html/$i" ]]; then
    noroot git clone git@github.com:api-api/$i.git ${VVV_PATH_TO_SITE}/public_html/$i
  else
    cd ${VVV_PATH_TO_SITE}/public_html/$i
    noroot git pull
  fi
done

for i in "${CUSTOM_REPO_NAMES[@]}"
do :
  if [[ ! -d "${VVV_PATH_TO_SITE}/public_html/$i" ]]; then
    noroot git clone git@github.com:api-api/$i.git ${VVV_PATH_TO_SITE}/public_html/$i
  else
    cd ${VVV_PATH_TO_SITE}/public_html/$i
    noroot git pull
  fi
done

# Install Console dependencies
cd ${VVV_PATH_TO_SITE}/public_html/console
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html/console/vendor" ]]; then
  noroot composer install
else
  noroot composer update
fi

mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{DOMAINS_HERE}}#${DOMAINS}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
