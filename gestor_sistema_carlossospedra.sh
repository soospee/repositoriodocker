#!/bin/bash

NOTAS="notas.txt"
BACKUP_DIR="backup"
BACKUP_FILE="backup_notas.tar.gz"

mostrar_info_sistema() {
    echo "Usuario actual: $USER"
    echo "Directorio de trabajo: $(pwd)"
    echo "Fecha y hora: $(date)"
    echo "Uso de disco:"
    df -h
}

comprobar_ruta() {
    read -rp "Introduce una ruta: " ruta
    if [[ -z "$ruta" ]]; then
        echo "Ruta vacía. Inténtalo de nuevo."
        return
    fi
    if [[ -e "$ruta" ]]; then
        if [[ -f "$ruta" ]]; then
            echo "Es un fichero."
        elif [[ -d "$ruta" ]]; then
            echo "Es un directorio."
        else
            echo "Existe, pero no es fichero ni directorio estándar."
        fi
        [[ -r "$ruta" ]] && echo "Permiso de lectura: Sí" || echo "Permiso de lectura: No"
        [[ -w "$ruta" ]] && echo "Permiso de escritura: Sí" || echo "Permiso de escritura: No"
        [[ -x "$ruta" ]] && echo "Permiso de ejecución: Sí" || echo "Permiso de ejecución: No"
    else
        echo "La ruta no existe."
    fi
}

añadir_nota() {
    read -rp "Escribe la nota: " nota
    if [[ -z "$nota" ]]; then
        echo "Nota vacía. No se ha guardado nada."
        return
    fi
    fecha=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$fecha][$USER] $nota" >> "$NOTAS"
    echo "Nota guardada."
}

listar_notas() {
    if [[ -f "$NOTAS" ]]; then
        echo "Contenido de $NOTAS:"
        cat "$NOTAS"
        total=$(wc -l < "$NOTAS")
        echo "Número total de notas: $total"
    else
        echo "No existe el fichero de notas."
    fi
}

copia_seguridad() {
    if [[ ! -f "$NOTAS" ]]; then
        echo "No existe $NOTAS. No se puede hacer copia de seguridad."
        return
    fi
    mkdir -p "$BACKUP_DIR"
    tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$NOTAS" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "Copia de seguridad creada en $BACKUP_DIR/$BACKUP_FILE"
    else
        echo "Error al crear la copia de seguridad."
    fi
}

salir() {
    echo "¡Hasta pronto!"
    exit 0
}

while true; do
    echo
    echo "----- MENÚ GESTOR DE SISTEMA -----"
    echo "1. Mostrar información del sistema"
    echo "2. Comprobar una ruta"
    echo "3. Añadir una nota"
    echo "4. Listar notas"
    echo "5. Copia de seguridad de notas"
    echo "6. Salir"
    read -rp "Selecciona una opción [1-6]: " opcion
    case "$opcion" in
        1) mostrar_info_sistema ;;
        2) comprobar_ruta ;;
        3) anadir_nota ;;
        4) listar_notas ;;
        5) copia_seguridad ;;
        6) salir ;;
        *) echo "Opción no válida. Inténtalo de nuevo." ;;
    esac
done
