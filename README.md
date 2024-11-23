## GUIA DE USO PARA AUTOMATIZAR UNA MIGRACIÓN

Con esta guía se quiere aumentar de manera eficaz el tiempo que lleve para migrar un proyecto

## Primer paso

**Ejecución**

```bash
./01-subconfig.sh --subdomain=beta-admin-focusit.gofocus.info --ssl=true --git=https://gitlab.com/project/project.git
```

**--subdomain**: Pondremos el dominio completo del que se usara un ej: servidor.local

**--ssl**: Si este usara SSL en caso que no, no se genera el certbot.

**--git**: repositorio que se usara para clonar el proyecto


**Con esto nos creara toda la configuración del apache, ssl, ean2site y clona el proyecto en si**

---

## Segundo paso

**Ejecución**


```bash
./03-enviroment.sh --subdomain=servidor.local --debug=true --db-user=test --db-pass=test --db-host=127.0.0.1 --db-port=3306 --db-name=db-test
```

**--subdomain**: Pondremos el dominio completo del que se usara un ej: servidor.local

**--debug**: Esto permite cambiar la configuración del ENV si sera modo DEBUG o no se debe colocar true o false.

**--db-user**: Nombre del usuario de la base de datos

**--db-pass**: Contraseña de la base de datos

**--db-host**: IP de la base de datos recomendación si es GCP usar la IP privada.

**--db-port**: Puerto que ocupa la base de datos.

**--db-name**: Nombre de la base de datos a usar.


**Con esto configuramos el enviroment para que luego el sistema funcione de forma correcta**

---
