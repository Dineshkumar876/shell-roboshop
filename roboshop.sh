 #!/bin/bash
 AMI_ID="ami-09c813fb71547fc4f"
 SG_ID="sg-0ccf0fa1fb801a27e"
 INSATANCES=("mysql" "mongodb" "redis" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
 ZONE_ID="Z0320932ZN57KIJC569U"
 DOMAIN_ID="vasadinesh.site"

 for instance in ${INSATANCEs[@]}
 do
aws ec2 run-instances \
    --image-id ami-09c813fb71547fc4f \
    --instance-type t2.micro \
    --security-group-ids sg-0ccf0fa1fb801a27e \ 
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=testing}]"
done