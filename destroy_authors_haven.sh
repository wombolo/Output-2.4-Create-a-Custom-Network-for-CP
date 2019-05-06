#!/usr/bin/env bash

# Bash error handling
set -o pipefail
set -ex

current_progress(){
  echo ""
  echo -e "\033[0;34m ========== ${1} =========== \033[0m"
}

#Running Terraform
run_terraform_destroy(){
    current_progress "Running Terraform Destroy"
    cd terraform_scripts
    terraform destroy -auto-approve -lock=false
}

main(){
    run_terraform_destroy
}


if command -v terraform ; then
    main
else
    echo "Please install terraform before proceeding"
fi
