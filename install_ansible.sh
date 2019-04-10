#!/usr/bin/env bash

install_ansible(){
  sudo apt-get update
  sudo apt-get install software-properties-common -y

  sudo apt-get-repository ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get install ansible -y
}

install_ansible