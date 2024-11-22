#!/bin/bash
for i in "$@"; do
    case $i in
    --subdomain=*)
        SUBDOMAIN="${i#*=}"
        shift
        ;;
    --debug=*)
        DEBUG="${i#*=}"
        shift
        ;;
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

if [ -z "$SUBDOMAIN" ]; then
    echo "Error: El parámetro --subdomain es obligatorio."
    exit 1
fi

if [ -z "$DEBUG" ]; then
    echo "Error: El parámetro --debug es obligatorio."
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

# Definir la ruta donde se va a crear el archivo __ENV.php
PATH_PROJECT="/var/www/html/${SUBDOMAIN}/api/inc"
PATH_ENV="${PATH_PROJECT}/__ENV.php"

# Crear el directorio si no existe
mkdir -p "${PATH_PROJECT}"

# Crear el archivo __ENV.php y llenarlo con los valores
cat <<EOL >$PATH_ENV
<?php # ENV DE EJEMPLO
const DEBUG = '${DEBUG}';  # Asegurarse de que 'DEBUG' sea interpretado como cadena.

const DB_HOST = '${DB_HOST}';
const DB_PORT = '${DB_PORT}';
const DB_USER = '${DB_USER}';
const DB_PASS = '${DB_PASS}';
const DB_NAME = '${DB_NAME}';

const SSH_IP = '127.0.0.1';
const SSH_USER = '';
const SSH_PASS = '';

const URL_API = 'https://${SUBDOMAIN}/api';
const URL_API_DWN = 'https://${SUBDOMAIN}/api';
const URL_WEB = 'https://${SUBDOMAIN}';
EOL


echo "Instalación de composer."
cd /var/www/html/${SUBDOMAIN}/api
composer install
echo "Se instalaron las dependencias de composer."

## Establecemos los permisos del archivo y directorio
sudo chown -R www-data:www-data /var/www/html/${SUBDOMAIN}
sudo chmod -R 775 /var/www/html/${SUBDOMAIN}
sudo chmod 644 $PATH_ENV

echo "Archivo __ENV.php creado en ${PATH_ENV}."


