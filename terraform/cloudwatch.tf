#Create an SNS Topic
resource "aws_sns_topic" "cpu_alarm_topic" {
  name = "cpu-alarm-topic"
}
#Create an SNS Topic and Subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cpu_alarm_topic.arn
  protocol  = "email"
  endpoint  = "doaahemaid01@gmail.com" 
}
# Create a CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "High-CPU-Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This alarm triggers when CPU utilization exceeds 70%."
  actions_enabled     = true

  alarm_actions = [
    aws_sns_topic.cpu_alarm_topic.arn
  ]

  dimensions = {
    InstanceId = module.ec2_instance["Slave"].instance_id
  }
}
