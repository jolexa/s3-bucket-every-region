# s3-bucket-every-region
AWS CloudFormation to create a unique bucket with lifecycle in every region.

### What?
This is a CloudFormation template to create a uniquely named bucket with a very
aggressive lifecycle policy. The template is deployed to every region via
[AWS CloudFormation StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html). There is an additional "helper" template to setup the
required StackSet IAM Roles, I chose `us-east-2` for my "Control Plane" for
this repo.

### Why?
Up until now, I used a unique but artisanally named bucket as a lambda zip file
artifact storage location. This bucket
[must](https://github.com/awslabs/serverless-application-model/issues/129)
be in the region that the lambda function is in. After I confirmed that the
artifact is only needed in the customer managed bucket until the function is
deployed (ie, minutes or some other _not very long_ value), I decided that I
could automate this and avoid clicking in the AWS Console.

### Result
A unique but similar named bucket in every region of this form:
`lambda-artifacts-${AWS::AccountId}-${AWS::Region}`
that expires objects after one day. Now I know a definitive artifact storage
location for my projects.

### Cost
When the bucket(s) have some objects in them for a day, there will be the
normal S3 Storage Costs. Otherwise some small fraction of a penny because things
like the AWS Cost Explorer does `List` operations on empty buckets. Sidenote: I
like how the billing observation system will make you incur charges so that you
know how much you owe. :neutral_face:
