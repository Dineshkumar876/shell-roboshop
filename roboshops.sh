 #!/bin/bash
 
 AMI_ID="ami-09c813fb71547fc4f"
 SG_ID="sg-0b818e73a2211b60c"
 INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
 ZONE_ID="Z0320932ZN57KIJC569U"
 DOMAIN_NAME="vasadinesh.site"
 for instance in ${INSTANCES[@]}
 do
    INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-09c813fb71547fc4f \
    --instance-type t2.micro \
    --security-group-ids sg-0b818e73a2211b60c \
    --tag-specifications 'ResourceType=instance, Tags=[{Key=Name, Value=test}]')
    if [ $instance != "frontend" ]
    then
    IP=$()
    RECORD_NAME="$instance.$DOMAIN_NAME"
    else
    IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    RECORD_NAME="$DOMAIN_NAME"
    fi
    echo "$instance IP address: $IP"
 done