#!/usr/bin/env bash

# Bash error handling
set -o pipefail
set -ex

ansible_dir='ansible_playbooks'

current_progress(){
  echo ""
  echo -e "\033[0;34m ========== ${1} =========== \033[0m"
}

#Running Terraform
run_terraform(){
    current_progress "Running Terraform"
    cd terraform_scripts
    terraform init -input=false # to initialize the working directory.

     # to create a plan and save it to the local file tfplan.
    if terraform plan -out=tfplan -input=false; then
        terraform apply -input=false tfplan
    fi
}

#Running Packer Build
build_packer_images(){

    # validate packer.json configuration
    if packer validate ${ansible_dir}/frontend/packer.json; then
        current_progress "Running Packer Build - frontend "
        packer build ${ansible_dir}/frontend/packer.json    # build packer.json configuration
    fi


    # validate backend/packer.json configuration
    if packer validate ${ansible_dir}/backend/packer.json; then
        current_progress "Running Packer Build - backend"
        packer build "${ansible_dir}"/backend/packer.json    # build packer.json configuration
    fi

    # validate database/packer.json configuration
    if packer validate ${ansible_dir}/database/packer.json; then
        current_progress "Running Packer Build - database"
        packer build ${ansible_dir}/database/packer.json    # build packer.json configuration
    fi
}

main(){
    build_packer_images
    run_terraform
}


if command -v packer terraform ; then
    main
else
    echo "Please install packer & terraform before proceeding"
fi
