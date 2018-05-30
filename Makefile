# Create StackSet and Instances, only awscli support

NAME='s3-bucket-every-region'
REGION='us-east-2'
MYACCOUNT=$(shell aws sts get-caller-identity --output text --query 'Account')
DESC="S3 Bucket with Lifecycle in Every Region (github.com/jolexa/s3-bucket-every-region)"
ALLREGIONS=$(shell aws ec2 describe-regions --query 'Regions[].{Name:RegionName}' --output text)

instance: stackset
	aws --region $(REGION) cloudformation create-stack-instances \
		--stack-set-name $(NAME) \
		--accounts $(MYACCOUNT) \
		--operation-preferences "MaxConcurrentPercentage=100" \
		--regions $(ALLREGIONS)

stackset: onetime
	aws --region $(REGION) cloudformation describe-stack-set \
		--stack-set-name $(NAME) > /dev/null || \
	aws --region $(REGION) cloudformation create-stack-set \
		--description "S3 Bucket with Lifecycle in Every Region (github.com/jolexa/s3-bucket-every-region)" \
		--stack-set-name $(NAME) \
		--template-body file://./s3-bucket.yml

onetime:
	aws --region $(REGION) cloudformation deploy \
		--template-file IAMRoles.yml \
		--stack-name 'stackset-iam-roles' \
		--capabilities 'CAPABILITY_NAMED_IAM' \
		--parameter-overrides "AdministratorAccountId=$(MYACCOUNT)" || exit 0
