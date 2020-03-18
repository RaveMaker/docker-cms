#! /bin/bash

set -e

case "$1" in

"cms")
  if [ ! -f /cms/requirements.txt ]; then
    # Copy cms to volume
    cp -rT /cms-dev /cms
  fi
  cd /cms || exit
  if [ ! -f /cms/.init-cms-db ]; then
    # Initialize DB schema (create tables)
    cmsInitDB || true

    # Import con_test example
    cd /cms/con_test || exit
    cmsImportUser --all || true
    cmsImportContest --import-tasks . || true

    # Create an admin user in the database (admin / admin)
    cmsAddAdmin admin -p admin || true

    # create a file to avoid reinit the db every time we restart the container
    echo "Delete me to reinitalize CMS DB" >/cms/.init-cms-db
  fi

  # Start CMS
  # Ugly hack bcs of bug - cmsProxyService will not accept param '-c ALL' so cmsResourceService wont be able to start it :/
  cmsProxyService -c 1 &
  cmsResourceService -a ALL
  ;;

"rws")
  # Start RWS
  cmsRankingWebServer
  ;;

*)
  echo "Please set command to cms/rws"
  ;;
esac
