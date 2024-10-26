#!/bin/bash

# Función para mostrar ayuda
function mostrar_ayuda() {
    echo "Uso: $0 [-h] [-p python_version] [-r requirements.txt] [-d entorno_virtual_path] [-i paquete] [-l]"
    echo
    echo "Opciones:"
    echo "  -h                      Mostrar esta ayuda"
    echo "  -p <versión>           Especificar la versión de Python (por defecto: python3)"
    echo "  -r <archivo>           Especificar un archivo de requisitos para instalar librerías"
    echo "  -d <entorno_virtual_path>   Especificar la ruta de un entorno virtual a eliminar"
    echo "  -i <paquete>           Instalar un paquete en un entorno virtual existente"
    echo "  -l                      Listar los paquetes instalados en un entorno virtual"
    exit 0
}

# Valores predeterminados
python_version="python3"
requirements_file=""
delete_virtual_env=""
install_package=""
env_path=""

# Parsear opciones
while getopts ":hp:r:d:i:l" opt; do
    case $opt in
        h) mostrar_ayuda ;;
        p) python_version="$OPTARG" ;;
        r) requirements_file="$OPTARG" ;;
        d) delete_virtual_env="$OPTARG" ;;
        i) install_package="$OPTARG" ;;
        l) list_packages=true ;;
        \?) echo "Opción inválida: -$OPTARG" >&2; mostrar_ayuda ;;
    esac
done

# Si se especifica una ruta de entorno virtual para eliminar
if [[ -n "$delete_virtual_env" ]]; then
    echo "Intentando eliminar el entorno virtual en: $delete_virtual_env"
    if [ ! -d "$delete_virtual_env" ] || [ ! -d "$delete_virtual_env/bin" ]; then
        echo "Error: La ruta '$delete_virtual_env' no es un entorno virtual válido."
        exit 1
    fi

    read -p "¿Estás seguro de que deseas eliminar el entorno virtual en '$delete_virtual_env'? (escribe 'eliminar' para confirmar): " confirm
    if [[ "$confirm" != "eliminar" ]]; then
        echo "Operación cancelada."
        exit 1
    fi

    echo "Eliminando el entorno virtual en '$delete_virtual_env'..."
    rm -rf "$delete_virtual_env"
    echo "Entorno virtual eliminado exitosamente."
    exit 0
fi


# Si se especifica un paquete para instalar en un entorno virtual existente
if [[ -n "$install_package" ]]; then
    read -p "Introduce la ruta del entorno virtual donde deseas instalar el paquete: " env_path
    if [ ! -d "$env_path" ] || [ ! -d "$env_path/bin" ]; then
        echo "Error: La ruta '$env_path' no es un entorno virtual válido."
        exit 1
    fi

    echo "Activando el entorno virtual en '$env_path'..."
    source "$env_path/bin/activate"
    
    echo "Instalando paquete '$install_package'..."
    pip install "$install_package" && echo "Paquete '$install_package' instalado exitosamente en el entorno virtual." || echo "Error al instalar el paquete."
    echo "Librerías instaladas:"
    pip freeze

    deactivate
    exit 0
fi

# Si se especifica la opción de listar paquetes
if [[ "$list_packages" == true ]]; then
    read -p "Introduce la ruta del entorno virtual del que deseas listar los paquetes: " env_path
    if [ ! -d "$env_path" ] || [ ! -d "$env_path/bin" ]; then
        echo "Error: La ruta '$env_path' no es un entorno virtual válido."
        exit 1
    fi

    echo "Listando los paquetes instalados en el entorno virtual en '$env_path':"
    source "$env_path/bin/activate"
    pip freeze
    deactivate
    exit 0
fi

# Preguntar el nombre y ubicación del entorno si no se está eliminando uno
read -p "Introduce el nombre del entorno virtual: " env_name
read -p "Introduce la ubicación donde deseas crear el entorno virtual (ruta completa): " env_location
env_path="$env_location/$env_name"

# Validar existencia y permisos de la ruta
if [ -d "$env_path" ]; then
    read -p "El entorno ya existe en esta ubicación. ¿Deseas sobrescribirlo? (s/n): " overwrite
    if [[ "$overwrite" != "s" ]]; then
        echo "Operación cancelada."
        exit 1
    fi
    rm -rf "$env_path"
fi
mkdir -p "$env_location"

# Verificar si Python está instalado
if ! command -v $python_version &> /dev/null; then
    echo "Error: $python_version no está instalado. Por favor, instálalo y vuelve a intentarlo."
    exit 1
fi

# Crear el entorno virtual
echo "Creando entorno virtual en '$env_path' usando $python_version..."
$python_version -m venv "$env_path" || { echo "Error al crear el entorno virtual. Asegúrate de tener $python_version."; exit 1; }

# Activar el entorno
source "$env_path/bin/activate"
echo "Entorno virtual '$env_name' activado."

# Instalar pip y actualizarlo
pip install --upgrade pip

# Instalar librerías desde el archivo de requisitos o básicas por defecto
if [[ -n "$requirements_file" && -f "$requirements_file" ]]; then
    echo "Instalando librerías desde $requirements_file..."
    pip install -r "$requirements_file" && echo "Librerías instaladas exitosamente." || echo "Error al instalar las librerías."
else
    echo "Instalando librerías básicas (requests, flask, pytest)..."
    pip install requests flask pytest && echo "Librerías básicas instaladas exitosamente." || echo "Error al instalar las librerías básicas."
fi

# Verificar la instalación
echo "Librerías instaladas:"
pip freeze


# Preguntar al usuario si el usuario quiere instalar más paquetes en el entorno virtual
while true; do
    read -p "¿Deseas instalar paquetes adicionales en el entorno virtual? (s/n): " install_more
    if [[ "$install_more" == "s" ]]; then
        read -p "Introduce el nombre del paquete que deseas instalar (o varios separados por espacio): " packages
        echo "Instalando paquetes: $packages..."
        pip install $packages && echo "Paquetes instalados exitosamente." || echo "Error al instalar los paquetes."
        echo "Paquetes instalados:"
        pip freeze
    elif [[ "$install_more" == "n" ]]; then
        break
    else
        echo "Opción no válida. Por favor, responde con 's' o 'n'."
    fi
done

# Abrir una nueva terminal según el sistema operativo después de finalizar la instalación de paquetes
echo "Abriendo una nueva terminal en el entorno virtual..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal -- bash -c "cd '$env_path'; source bin/activate; exec bash"
    elif command -v xterm &> /dev/null; then
        xterm -e "cd '$env_path'; source bin/activate; bash"
    else
        echo "No se pudo abrir una nueva terminal. Por favor, instala 'gnome-terminal' o 'xterm'."
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    osascript <<EOF
        tell application "Terminal"
            do script "cd '$env_path'; source bin/activate"
            activate
        end tell
EOF
else
    echo "Sistema operativo no soportado para la apertura automática de una nueva terminal."
fi

# Recordatorio de activación/desactivación
echo "Para activar el entorno en el futuro, usa: source $env_path/bin/activate"
echo "Para desactivar el entorno, usa: deactivate"
