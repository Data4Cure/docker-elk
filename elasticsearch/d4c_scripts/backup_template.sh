#!/bin/bash

HOST_ADDR=localhost:9200
REPO_ID=dev_4
BUCKET=d4c-dev4
REGION=us-east-1
BUCKET_PREFIX=elk-backup
AWS_ACCESS_KEY_ID=x
AWS_SECRET_KEY=x
ELASTIC_CREDENTIALS=x:x

case "$1" in
    "new-repo" ) echo "New repo $REPO_ID at s3://$BUCKET/$BUCKET_PREFIX"
        curl --user "${ELASTIC_CREDENTIALS}" -XPUT $HOST_ADDR/_snapshot/$REPO_ID -d "{
            \"type\": \"s3\",
            \"settings\": {
                \"bucket\": \"$BUCKET\",
                \"region\": \"$REGION\",
                \"base_path\": \"$BUCKET_PREFIX\",
                \"access_key\": \"$AWS_ACCESS_KEY_ID\",
                \"secret_key\": \"$AWS_SECRET_KEY\"
            }
        }"
    ;;
    "backup-snapshot" )
        if test -z "$2" ; then
            echo "You have to provide snapshot id."
        else
            if test -z "$3" ; then
                echo "Creating full snapshot $2..."
                curl --user "${ELASTIC_CREDENTIALS}" -XPUT $HOST_ADDR/_snapshot/$REPO_ID/$2?wait_for_completion=true
            else
                echo "Creating snapshot $2 of index $3..."
                curl --user "${ELASTIC_CREDENTIALS}" -XPUT $HOST_ADDR/_snapshot/$REPO_ID/$2?wait_for_completion=true -d "{
                    \"indices\": \"$3\"
                }"
            fi
        fi
    ;;
    "restore-snapshot" )
        if test -z "$2" ; then
            echo "You have to provide snapshot id."
        else
            if test -z "$3" ; then
                echo "Restoring all indices from snapshot $2..."
                curl --user "${ELASTIC_CREDENTIALS}" -XPOST $HOST_ADDR/_snapshot/$REPO_ID/$2/_restore
            else
                echo "Restoring index $3 from snapshot $2..."
                curl --user "${ELASTIC_CREDENTIALS}" -XPOST $HOST_ADDR/_snapshot/$REPO_ID/$2/_restore -d "{
                    \"indices\": \"$3\"
                }"
            fi
        fi
    ;;
    * )
    echo "Wrong command. Valid commands are:
        new-repo repo_name
        backup-snapshot snap_name [index]
        restore-snapshot snap_name [index]"
    ;;
esac
