#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
PATH_CONF="/etc/apache2/sites-available"
APACHE_LOG_DIR="/var/log/apache2"

for i in "$@"; do
    case $i in
    --subdomain=*)
        SUBDOMAIN="${i#*=}"
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

if [ -z "$SSL" ]; then
    echo "Error: El parámetro --ssl es obligatorio."
    exit 1
fi

# Crear carpeta de DocumentRoot si no existe
DOC_ROOT="/var/www/html/${SUBDOMAIN}"

if [ ! -d "$DOC_ROOT" ]; then
    /usr/bin/mkdir -p "$DOC_ROOT"
    if [ -n "$GIT" ]; then
        echo "Clonando el repositorio ${GIT} en ${DOC_ROOT}..."
        /usr/bin/git clone "${GIT}" "${DOC_ROOT}/api" || {
            echo "Error al clonar el repositorio. Verifica la URL."
            exit 1
        }
    else
        echo "Advertencia: No se proporcionó un repositorio para clonar."
        echo "<h1>Bienvenido ${SUBDOMAIN}</h1>" > "${DOC_ROOT}/index.html"
    fi
else
    echo "Carpeta de DocumentRoot ya existe en ${DOC_ROOT}."
fi

## Configuración Apache
echo "Creando la configuración del nuevo subdominio..."
CONFIG_FILE="${PATH_CONF}/${SUBDOMAIN}.conf"

echo "Creando archivo de configuración para el subdominio..."
sudo bash -c "cat <<EOL >$CONFIG_FILE
<VirtualHost *:80>
    ServerName ${SUBDOMAIN}
    DocumentRoot ${DOC_ROOT}

    <Directory ${DOC_ROOT}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    RewriteEngine on
    RewriteCond %{SERVER_NAME} =${SUBDOMAIN}
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]

</VirtualHost>
EOL"

echo "Archivo de configuración creado en ${CONFIG_FILE}."

# Habilitar configuración de Apache
echo "Habilitando el sitio..."
sudo a2ensite "${SUBDOMAIN}.conf"

# Configurar SSL si está habilitado
if [ "$SSL" == "true" ]; then
    echo "Configurando SSL para ${SUBDOMAIN}..."
    sudo certbot --apache -d "$SUBDOMAIN" --non-interactive --agree-tos --email admin@"$SUBDOMAIN" || {
        echo "Error al configurar SSL."
        exit 1
    }
else
    echo "SSL no habilitado para ${SUBDOMAIN}."
fi

# Recargar Apache
echo "Recargando Apache..."
sudo systemctl reload apache2


echo "Configuración completa. El subdominio ${SUBDOMAIN} está listo."
