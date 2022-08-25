# VMware Fusion CLI command functions

# define VMware VM base directory
baseDir="$HOME/Virtual Machines.localized"

# Suspend all VMs
susall() {
  # Get list of running VMs
  vmList=$(vmrun list)

  # suspend all VMs
  for vm in $vmList; do
    vmrun -T fusion suspend "$vm" &
  done
}

# Suspend VM by name
susvm() {
  # make sure a VM name was provided
  if [[ -z $1 ]]; then
    echo "ERROR: no VM name provided"
    echo "Syntax: ${FUNCNAME[0]} <name>"
    return
  else
    name=$1
  fi

  # find vmx file
  vmxFile=$(find "$baseDir" -type f -name "*vmx" -exec grep -l $name {} \;)

  # make sure vmx file exists at reported location
  if [[ ! -f "$vmxFile" ]]; then
    echo "ERROR: "$vmxFile" not found"
    return
  fi

  # Suspend VM
   vmrun -T fusion suspend "$vmxFile" &
}
