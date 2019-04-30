# Output 2.4-Create a Custom Network for Check Point
Output 2.4: Create a Custom Network for your Checkpoint Using Terraform.

## Introduction
This is a project that showcases automation and pre-configuration of the VPC network with private & public subnets and other necessary infrastructure needed by the application to operate. 
It also demonstrates the automated build process of a JS application from creation of AMI images till when the image is launched with terraform all in AWS cloud environment.

### Preview of Infrastructure to accomplish
 ![](media/Screenshot%202019-04-08%20at%2012.11.18%20PM.png)
 
### Prerequisites
Ensure to have installed AWS CLI, afterwards run `aws configure`.
You can follow this [**Guide**](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) to install it.

It would prompt you to enter your access key, secret keys which are needed by both packer and terraform to build & launch images.
Follow this guide below to obtain the keys.

#### To obtain your access & secret keys: 
1. Click on the IAM service 

    ![](media/Screenshot%202019-04-30%20at%2010.59.55%20AM.png)   
     
2. Click on Users link & and then Add User 

    ![](media/Screenshot%202019-04-30%20at%2011.04.15%20AM.png)
    
3. Type a name of choice, then click programmatic access 

    ![](media/Screenshot%202019-04-30%20at%2011.06.05%20AM.png)
    
4. Click on attach existing policies directly & filter by admin. Then choose it. 

    ![](media/Screenshot%202019-04-30%20at%2011.07.07%20AM.png)
    
5. Afterwards, you'll be required to download a credentials file, ensure to keep it safe as you'll not be able to download them again.


After configuring aws credentials, an ssh key would be needed in order to allow `terraform` have access to instances in order to provision required configurations and packages.

### Generating a new SSH key
_Please skip this step if you already have an ssh key available_

1. Open Terminal.

2. Paste the text below, substituting in your email address.
    
    `$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`.
    This creates a new ssh key, using the provided email as a label.
    
    `> Generating public/private rsa key pair.`
    
3. When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.
    `> Enter a file in which to save the key (/Users/username/.ssh/id_rsa): [Press enter]`
    
4. At the prompt, type a secure passphrase.

    `> Enter passphrase (empty for no passphrase): [Type a passphrase]`
    
    `> Enter same passphrase again: [Type passphrase again]`

```
Ensure the name of the SSH key is `id_rsa` and is stored in the directory `~/.ssh/id_rsa.pub`.
```
 
### Uploading the SSH key to AWS
In order to allow terraform have access to AWS.
 
1. After logging into the account, Click on services, and then EC2 service link.

    ![](media/Screenshot%202019-04-30%20at%2010.41.20%20AM.png)

2. Then click on the Key Pairs link

    ![](media/Screenshot%202019-04-30%20at%2010.42.39%20AM.png)

3. Then click on Import Key Pair

    ![](media/Screenshot%202019-04-30%20at%2010.43.16%20AM.png)

4. Then choose the id_rsa.pub file in `~/.ssh/id_rsa.pub`. Then give it a name `id_rsa`

    ![](media/Screenshot%202019-04-30%20at%2010.44.47%20AM.png)


### How to begin Infrastructure build.
- Clone this repo by running `git clone https://github.com/wombolo/Output-2.4-Create-a-Custom-Network-for-CP.git`
- Change directory into the project folder. `cd Output-2.4-Create-a-Custom-Network-for-CP` 
- Ensure the shell script is executable by running `chmod u+x launch_authors_haven.sh`.
- Run the command `bash launch_authors_haven.sh` to begin the building of machine images with packer, configuration & installation of required packages and codebase are installed on the images with ansible and then creating the infrastructure with Terraform.

The script creates machine images for the frontend, backend and database instances. It also ensures the frontend instance is launched into the public subnet, while the backend and database instances are launched into the private subnet in order to prevent access to them from the internet.

### How to destroy Infrastructure built.
In order to manage resources, after successfully building & experimenting, its essential to destroy the infrastructure. 
To do that,
- Ensure the shell script is executable by running `chmod u+x destroy_authors_haven.sh`. 
- Run the command `./destroy_authors_haven.sh`.


### Technology and Platforms Used

- [AWS](aws.amazon.com)
- [Packer](https://www.packer.io)
- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io)

