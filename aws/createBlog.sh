#!/bin/bash


#source https://lustforge.com/2016/02/27/hosting-hugo-on-aws/

#Requirements
##pip , awscli

###############
##CREATE BLOG##
###############

# Set your domain here
YOUR_DOMAIN="libert.xyz"
REGION="us-east-1"

BUCKET_NAME="${YOUR_DOMAIN}-blog-cdn"
LOG_BUCKET_NAME="${BUCKET_NAME}-blog-logs"

# One fresh bucket please!
aws s3 mb s3://$BUCKET_NAME --region $REGION
# And another for the logs
aws s3 mb s3://$LOG_BUCKET_NAME --region $REGION


# Let AWS write the logs to this location
aws s3api put-bucket-acl --bucket $LOG_BUCKET_NAME \
--grant-write 'URI="http://acs.amazonaws.com/groups/s3/LogDelivery"' \
--grant-read-acp 'URI="http://acs.amazonaws.com/groups/s3/LogDelivery"'

# Setup logging
LOG_POLICY="{\"LoggingEnabled\":{\"TargetBucket\":\"$LOG_BUCKET_NAME\",\"TargetPrefix\":\"$BUCKET_NAME\"}}"
aws s3api put-bucket-logging --bucket $BUCKET_NAME --bucket-logging-status $LOG_POLICY


#S3 bucket website
aws s3api put-bucket-website --bucket $BUCKET_NAME --website-configuration file://website.json


#CloudFront Setup
aws  configure  set preview.cloudfront true # Honey badger don't care

#making a distribution
aws cloudfront create-distribution --distribution-config file://distroConfig.json
