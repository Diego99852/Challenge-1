
if [ "$#" -ne 8 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_os> <num_cpus> <ram_gb> <vram_mb> <tam_disco_gb> <controlador_sata> <controlador_ide>"
    exit 1
fi

NOMBRE_VM=$1
TIPO_OS=$2
NUM_CPUS=$3
RAM_GB=$4
VRAM_MB=$5
TAM_DISCO_GB=$6
CONTROLADOR_SATA=$7
CONTROLADOR_IDE=$8

RAM_MB=$((RAM_GB * 1024))
TAM_DISCO_MB=$((TAM_DISCO_GB * 1024))

VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_OS" --register

VBoxManage modifyvm "$NOMBRE_VM" --cpus "$NUM_CPUS" --memory "$RAM_MB" --vram "$VRAM_MB"

VBoxManage createmedium disk --filename "$NOMBRE_VM.vdi" --size "$TAM_DISCO_MB" --format VDI
VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_SATA" --add sata --controller IntelAhci
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_SATA" --port 0 --device 0 --type hdd --medium "$NOMBRE_VM.vdi"

VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_IDE" --add ide
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_IDE" --port 0 --device 0 --type dvddrive --medium emptydrive

echo "Configuracion completa de la maquina virtual '$NOMBRE_VM':"
VBoxManage showvminfo "$NOMBRE_VM"
