# aliases
alias tf="terraform"
alias tfaa="terraform apply -auto-approve"
alias tfda="terraform destroy -auto-approve"
alias tfp="terraform plan"

# functions

# Run terraform destoy repeatedly until exit status is 0
tfkill() {
  count=1
  while [ 1 ]; do
    echo "Starting 'terraform destroy' # $count"
    terraform destroy -auto-approve
    status=$?
    if [[ $status == 0 ]]; then break; fi
    ((count++))
  done
  echo -e "\nTerraform deployment fully destroyed (executions: $count)\n"
}
