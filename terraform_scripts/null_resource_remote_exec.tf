//Helper function to update database link on the backend_instance
resource "null_resource" "connect_to_api_backend_instance" {
  connection {
    bastion_host = "${aws_instance.bastion-host.public_ip}"
    host     = "${aws_instance.backend_instance.private_ip}"
    user     = "ubuntu"
    agent    = true
  }

//  Forward Port 5432 on backend instance to DB instance:5432
//  Update DB host on backend instance

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",

      "sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf",
      "sudo sysctl -p",
      "sudo systemctl restart iptables",

      "sudo iptables -t nat -A PREROUTING -p tcp --dport 5432 -j DNAT --to-destination ${aws_instance.database_instance.private_ip}:5432",
      "sudo iptables -t nat -A POSTROUTING -p tcp -d ${aws_instance.database_instance.private_ip} --dport 5432 -j SNAT --to-source ${aws_instance.backend_instance.private_ip}",
      "sudo iptables-save | sudo tee /etc/iptables.up.rules",

      "cd /home/ubuntu/authors_haven_api",
      "sed -i 's/DBLINK/${aws_instance.database_instance.private_ip}/g' .env",
      "sudo npm run-script build",
      "pm2 start npm -- start",
      "sudo systemctl restart nginx",
      "sudo node_modules/.bin/sequelize db:migrate",
      "sudo node_modules/.bin/sequelize db:seed",
    ]
  }
  depends_on = ["aws_instance.bastion-host", "aws_instance.database_instance", "aws_instance.backend_instance"]
}


//  Update Backend host on frontend instance

resource "null_resource" "connect_to_frontend_instance" {
  connection {
    bastion_host = "${aws_instance.bastion-host.public_ip}"
    host     = "${aws_instance.frontend_instance.private_ip}"
    user     = "ubuntu"
    agent    = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "cd /home/ubuntu/authors_haven",
      "sed -i 's|export const basePath = BACKEND_API|export const basePath =\"http://${aws_instance.bastion-host.public_ip}/api/v1/\"|g' src/utils/basePath.js",
      "sudo npm run-script build",
      "pm2 start npm -- start",
      "sudo systemctl restart nginx",
    ]
  }
  depends_on = ["aws_instance.bastion-host", "aws_instance.frontend_instance"]
}
