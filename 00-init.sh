#!/bin/bash

for i in "$@"
do
case $i in
    --config=*)
    CONFIG="${i#*=}"
    shift
    ;;
    --subdomain=*)
    SUBDOMAIN="${i#*=}"
    shift
    ;;
    --debug=*)
    DEBUG="${i#*=}"
    shift
    ;;
    --ssl=*)
    SSL="${i#*=}"
    shift
    ;;
    --git=*)
    GIT="${i#*=}"
    shift
    ;;
    --db-user=*)
    DB_USER="${i#*=}"
    shift
    ;;
    --db-password=*)
    DB_PASSWORD="${i#*=}"
    shift
    ;;
    --db-host=*)
    DB_HOST="${i#*=}"
    shift
    ;;
    --db-port=*)
    DB_PORT="${i#*=}"
    shift
    ;;
    --db-name=*)
    DB_NAME="${i#*=}"
    shift
    ;;
    *)
    echo "Unknown option $i"
    exit 1
    ;;
esac
done

if [ -z "$CONFIG" ]; then
    echo "Error: El parámetro --config es obligatorio."
    exit 1
fi

if [ -z "$CONFIG" = "full"]; then

    if [ -z "$SUBDOMAIN" ]; then
        echo "Error: El parámetro --subdomain es obligatorio."
        exit 1
    fi

    if [ -z "$DEBUG" ]; then
        echo "Error: El parámetro --debug es obligatorio."
        exit 1
    fi

    if [ -z "$SSL" ]; then
        echo "Error: El parámetro --ssl es obligatorio."
        exit 1
    fi

    if [ -z "$GIT" ]; then
        echo "Error: El parámetro --git es obligatorio."
        exit 1
    fi

    if [ -z "$DB_USER" ]; then
        echo "Error: El parámetro --db-user es obligatorio."
        exit 1
    fi

    if [ -z "$DB_PASS" ]; then
        echo "Error: El parámetro --db-pass es obligatorio."
        exit 1
    fi

    if [ -z "$DB_HOST" ]; then
        echo "Error: El parámetro --db-host es obligatorio."
        exit 1
    fi

    if [ -z "$DB_PORT" ]; then
        echo "Error: El parámetro --db-port es obligatorio."
        exit 1
    fi

    if [ -z "$DB_NAME" ]; then
        echo "Error: El parámetro --db-name es obligatorio."
        exit 1
    fi


    ./01-subconfig.sh --subdomain $SUBDOMAIN --ssl $SSL --git $GIT
    #./02-createdb.sh --db-user $DB_USER --db-pass $DB_PASS --db-host $DB_HOST --db-port $DB_PORT --db-name $DB_NAME
    ./03-enviroment.sh --subdomain $SUBDOMAIN --debug $DEBUG --db-user $DB_USER --db-pass $DB_PASS --db-host $DB_HOST --db-port $DB_PORT --db-name $DB_NAME

elif [ "$CONFIG" = "subdomain" ]; then
    if [ -z "$SUBDOMAIN" ]; then
        echo "Error: El parámetro --subdomain es obligatorio."
        exit 1
    fi

    if [ -z "$SSL" ]; then
        echo "Error: El parámetro --ssl es obligatorio."
        exit 1
    fi

    if [ -z "$GIT" ]; then
        echo "Error: El parámetro --git es obligatorio."
        exit 1
    fi

    ./01-subconfig.sh --subdomain $SUBDOMAIN --ssl $SSL --git $GIT

elif [ "$CONFIG" = "database" ]; then
    if [ -z "$DB_USER" ]; then
        echo "Error: El parámetro --db-user es obligatorio."
        exit 1
    fi

    if [ -z "$DB_PASS" ]; then
        echo "Error: El parámetro --db-pass es obligatorio."
        exit 1
    fi

    if [ -z "$DB_HOST" ]; then
        echo "Error: El parámetro --db-host es obligatorio."
        exit 1
    fi

    if [ -z "$DB_PORT" ]; then
        echo "Error: El parámetro --db-port es obligatorio."
        exit 1
    fi

    if [ -z "$DB_NAME" ]; then
        echo "Error: El parámetro --db-name es obligatorio."
        exit 1
    fi

    ./02-createdb.sh --db-user $DB_USER --db-pass $DB_PASS --db-host $DB_HOST --db-port $DB_PORT --db-name $DB_NAME
else
    echo "Unknown resource type $CONFIG"
    exit 1
fi