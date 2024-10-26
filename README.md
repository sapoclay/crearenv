# Crearenv - Un script para la gestión (básica) de entornos virtuales en Python

Este script permite al usuario crear, eliminar y gestionar entornos virtuales de Python fácilmente. 
También facilita la instalación de paquetes y la activación de entornos virtuales, lo que resulta útil para mantener proyectos de Python aislados y organizados.

## Características

- **Crear un entorno virtual**: Configura un nuevo entorno virtual en una ubicación especificada.
- **Eliminar un entorno virtual**: Permite eliminar un entorno virtual existente.
- **Instalar paquetes**: Instala paquetes de Python en un entorno virtual existente o recién creado, ya sea desde un archivo de requisitos o manualmente.
- **Listar paquetes instalados**: Muestra los paquetes instalados en un entorno virtual específico.
- **Abrir una nueva terminal**: Inicia una nueva terminal con el entorno virtual activado.

## Requisitos

- **Python**: Asegúrate de tener instalada la versión de Python que deseas usar. Puedes especificar la versión utilizando la opción `-p` al ejecutar el script.
- **pip**: Se utiliza para instalar los paquetes de Python. El script se encargará de actualizar `pip` automáticamente.

## Uso

Para ejecutar el script, abre una terminal (Ctrl+Alt+T) y navega al directorio donde se encuentra el archivo. Usa el siguiente comando:

```
chmod +x nombre_del_script.sh
```
Ahora ya puede ejecutar lo siguiente: 

![crearenv](https://github.com/user-attachments/assets/1fc7c56f-217c-4b10-ae1b-bd20df023666)

```
./crearvenv.sh [opciones]
```
Opciones

    -h: Muestra la ayuda y las opciones disponibles.
    -p <versión>: Especifica la versión de Python (por defecto: python3).
    -r <archivo>: Especifica un archivo de requisitos para instalar librerías.
    -d <ruta_del_entorno_virtual>: Especifica la ruta de un entorno virtual a eliminar.
    -i <paquete>: Instala un paquete en un entorno virtual existente.
    -l: Lista los paquetes instalados en un entorno virtual.

[!Note] ## Ejemplo de uso

Crear un nuevo entorno virtual:

```

./crearvenv.sh

```

Eliminar un entorno virtual existente:

```

./crearvenv.sh -d /ruta/al/entorno_virtual

```

Instalar paquetes desde un archivo de requisitos:

```

./crearvenv.sh -r requisitos.txt

```
Instalar un paquete específico en un entorno virtual existente:

```

./crearvenv.sh -i nombre_paquete

```

Listar paquetes instalados en un entorno virtual:

```
    ./crearvenv.sh -l
```

Notas Adicionales

    Asegúrate de tener permisos de escritura en el directorio donde deseas crear el entorno virtual.
    Si el entorno virtual ya existe, el script te preguntará si deseas sobrescribirlo.
    Al final de las instalaciones, el script abrirá una nueva terminal en la ubicación del entorno virtual, donde podrás continuar trabajando con él.

Contribuciones

Si deseas contribuir al proyecto, siéntete libre de abrir un issue o un pull request en este repositorio.

Licencia

Este proyecto está bajo la Licencia MIT. Para más detalles, consulta el archivo LICENSE.
