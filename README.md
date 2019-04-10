# Output 2.4-Create a Custom Network for Check Point
Output 2.4: Create a Custom Network for your Checkpoint Using Terraform.

## Introduction
This is a project that showcases automation and pre-configuration of the VPC network with private & public subnets and other necessary infrastructure needed by the application to operate. 
It also demonstrates the automated build process of a JS application from creation of AMI images till when the image is launched with terraform all in AWS cloud environment.

 ![](media/Screenshot%202019-04-08%20at%2012.11.18%20PM.png)
 
 `-Preview of Infrastructure to accomplish`

### Prerequisites
Ensure to have installed AWS CLI, afterwards run `aws configure`, it would prompt you to enter your access key, secret keys
which are needed by both packer and terraform to build & launch images.

After configuring aws credentials, an ssh key would be needed in order to allow `terraform` have access to instances in order to provision required configurations and packages.

Follow this tutorial: [SSH Keygen tutorial](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
and ensure the name of the SSH key is `id_rsa`.
 

### How to begin Terraform build.

- Run the command `bash launch_authors_haven.sh` to begin the build with packer & configuration & launching process with Terraform.

The script creates machine images for the frontend, backend and database instances. It also ensures the frontend instance is launched into the
public subnet, while the backend and database instances are launched into the private subnet in order to prevent access to them from the internet.


### Technology and Platforms Used

- [AWS](aws.amazon.com)
- [Packer](https://www.packer.io)
- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io)

