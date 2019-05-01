# aws_resource.tf

provider "aws" {
  //Access Keys are automaticallygotten from ~/.aws directory
  region     = "${var.aws_region}"
}

resource "aws_key_pair" "my_key" {
  public_key = "${file("~/.ssh/id_rsa.pub")}"
  key_name = "id_rsa"
}


//Configure & Launch bastion host instance
resource "aws_instance" "bastion-host" {
  ami = "${var.bastion-ami-id}"
  instance_type = "t2.micro"
  source_dest_check = false

  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  associate_public_ip_address = true
  subnet_id = "${aws_subnet.public.id}"
  key_name = "${aws_key_pair.my_key.key_name}"

  depends_on = ["aws_key_pair.my_key"]
  tags {
    Name = "bastion-host_Authors_haven"
  }


  //Configure the bastion host as a port forwarder for incoming traffic going to the backend
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
    }

    inline = [
      "sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf",
      "sudo sysctl -p",
      "sudo systemctl restart iptables",

      "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${aws_instance.backend_instance.private_ip}:80",
      "sudo iptables -t nat -A POSTROUTING -p tcp -d ${aws_instance.backend_instance.private_ip} --dport 80 -j SNAT --to-source ${aws_instance.bastion-host.private_ip}",
      "sudo iptables-save | sudo tee /etc/iptables.up.rules",
    ]
  }

}


//Launch database instance
resource "aws_instance" "database_instance" {
  ami = "${data.aws_ami.database_ami.id}"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.database.id}"]

  subnet_id = "${aws_subnet.private.id}"
  key_name = "${aws_key_pair.my_key.key_name}"

  depends_on = ["aws_key_pair.my_key"]
  tags {
    Name = "database-Authors haven"
  }
}

//Launch backend_instance
resource "aws_instance" "backend_instance" {
  ami = "${data.aws_ami.backend_ami.id}"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  subnet_id = "${aws_subnet.private.id}"
  key_name = "${aws_key_pair.my_key.key_name}"

  depends_on = ["aws_instance.database_instance"]
  tags {
    Name = "backend-Authors haven"
  }
}


//Launch frontend_instance
resource "aws_instance" "frontend_instance" {
  ami = "${data.aws_ami.frontend_ami.id}"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.web.id}"]

  subnet_id = "${aws_subnet.public.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.my_key.key_name}"

  depends_on = ["aws_instance.backend_instance"]
  tags {
    Name = "frontend-Authors haven"
  }
}

//To display IP address of the instance in the terminal
output "bastion_instance ip" {
  value = "${aws_instance.bastion-host.public_ip}"
}
