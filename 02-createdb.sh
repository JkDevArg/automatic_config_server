#!/bin/bash

for i in "$@"; do
    case $i in
    --db-user=*)
        DB_USER="${i#*=}"
        shift
        ;;
    --db-pass=*)
        DB_PASS="${i#*=}"
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
