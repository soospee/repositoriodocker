#/bin/bash


help(){
    echo "Uso: admin_tool.sh [opción] [parámetros]"
}


info(){
    echo "Ruta: $(pwd)"
    echo "Ficheros: $(find . -type f | wc -l)"
    echo "Directorios: $(find . -type d | wc -l)"
}


backup(){
    if [[ -d "$1" ]]; then
        echo "Ruta valida"
    fi
    mkdir backups
    name="backup_$(date +"%Y%m%d_%H%M%S").tar.gz"
    tar -czf "$name" "$1"
    echo "Backup creado: $name"
    du -h "$name"
}


clean(){
    temp_files=$(find . -maxdepth 1 -type f -name "*.tmp")
    count=0
    for f in *.tmp; do
        read -p "¿Eliminar $f? [s/n]: " r
        if [[ "$r" == "s" ]]; then
            rm "$f"
           count=$((count + 1))
        fi
    done
    echo "Ficheros eliminados: $count"
}

 
monitor(){
    {
    date
    df -h
    echo "----------------------"
    } >> system.log

    echo "Registro añadido a system.log"
}



case "$1" in
    help) help;;
    info) info;;
    backup) backup "$2";;
    clean) clean;;
    monitor) monitor;;
    *) help;exit 1;;
esac