resource "aws_launch_configuration" "web_lc" {
  name = "web_lc"
  image_id      = var.web_amis[var.aws_region]
  key_name = aws_key_pair.web.key_name
  instance_type = var.web_instance_type
  security_groups = [aws_security_group.web_sg.id]
  user_data = file("scripts/apache.sh")
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "sharks_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_configuration      = aws_launch_configuration.web_lc.name
  vpc_zone_identifier       = local.pub_sub_ids
}

resource "aws_autoscaling_policy" "AddInstancesPolicy" {
  name                   = "AddInstancesPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "RemoveInstancesPolicy" {
  name                   = "RemoveInstancesPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_ge_80" {
  alarm_name                = "avg_cpu_ge_80"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

    alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.AddInstancesPolicy.arn]

}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_le_30" {
  alarm_name                = "avg_cpu_le_30"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

    alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.RemoveInstancesPolicy.arn]

}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
