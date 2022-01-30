# 01 - Bastion Host Setup
The CloudFormation templates in this folder are ready to use upon fulfilling the prerequisites.

## Getting Started
### Prerequisites
Please ensure you have the following:
- AWS account
- An IAM user or role with required IAM permissions to run CloudFormation and the all required services via AWS Mangement Console
    - For simplicity, you can create an IAM user with `AdministratorAccess`
- Key Pair to access EC2 instance
- Your Public IPv4 address
    - Visit `https://checkip.amazonaws.com/`
    - The value shown in the page is your public IPv4 address. 
    - Remember to append /32
- S3 Bucket

## Usage

### High Level Flow
1. Clone this repository
2. Create S3 bucket if not done so.
3. Upload both files into the S3 bucket created in step 1
4. Create a new CloudFormation stack
  - Provide the S3 bucket URL for the `main.yml` file
5. Upon the completion of the provisioning of the resources via the CloudFormation, you can now access the EC2 instances setup.

### Create CloudFormation Stack
1. In the searchbar, enter `CloudFormation`. Select the CloudFormation service
2. Click `Create Stack`
3. Under the `Specify template` section, provide the S3 URL for `main.yml`.
4. Please provide the following:
    - Stack name
    - PublicSubnet
    - DefaultPublicSubnetCidr
    - KeyName 
5. Click `Next` 3 times.
    - You can leave the configurations under `Configure stack options` as default.
7. Review the parameters under Step 2.
8. Acknowledge the following capabilities. Click `Create stack`