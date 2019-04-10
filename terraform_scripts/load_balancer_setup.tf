# Setup Load balancer for the Frontend Instance
resource "aws_lb" "app-loadbalancer" {
  name = "app-loadbalancer"
  internal = false
  load_balancer_type = "application"

  ip_address_type    = "ipv4"
  subnets            = ["${aws_subnet.public.id}", "${aws_subnet.private.id}"]
  security_groups    = ["${aws_security_group.web.id}"]

  tags {
    Name = "Frontend-App-Load-balancer"
  }
}

resource "aws_lb_target_group" "app-target-group" {
  name        = "app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.output2_4_vpc.id}"
  target_type = "instance"
}


resource "aws_lb_target_group_attachment" "lb-target-group" {
  target_group_arn = "${aws_lb_target_group.app-target-group.arn}"
  target_id = "${aws_instance.frontend_instance.id}"
  port = "80"
}


resource "aws_lb_listener" "lb-listener" {
  "default_action" {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.app-target-group.arn}"
  }

  load_balancer_arn = "${aws_lb.app-loadbalancer.arn}"
  port = 80
  protocol = "HTTP"
}
