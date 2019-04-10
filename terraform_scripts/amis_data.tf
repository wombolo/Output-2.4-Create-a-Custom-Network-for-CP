# aws_resource.tf

//Variable specifying my image built by packer, picking the latest ami-id
data "aws_ami" "frontend_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["Authors_haven-Frontend*"]
  }
  owners = ["874411430277"]
}

//Fetch backend_ami
data "aws_ami" "backend_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["Authors_haven-API*"]
  }
  owners = ["874411430277"]
}

//Fetch database_ami
data "aws_ami" "database_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["Authors_haven-DB*"]
  }
  owners = ["874411430277"]
}
