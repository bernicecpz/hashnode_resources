# Create Lambda-backed Custom Resource

## Prerequisites

# Python Modules for Lambda Layers
1. You will need to create the .zip file archive containing the libraries.

```shell
# Create a python virtual environment, in this example, we will call it layers
python3 -m venv layers

# Enable the virtual environment
. layers/bin/activiate

# Install the required libraries
pip3 install -r requirements.txt
```
2. Compress the `layers` folder into a zip file.


# S3 Bucket
- Create a S3 Bucket to host the .zip file archive as created above
- Refer to https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html for steps to create a S3 Bucket

# Usage
In your AWS Management Console, navigate to CloudFormation Dashboard
1. Click on "Create Stack"
2. Under "Specify template", select "Upload a template file"
3. Select the "custom_resource.yml" file and click "Next"
4. Fill up the following fields
 - Stack name
 - S3BucketName: Put the name of the S3 Bucket you created above
5. Click "Next" until you reach the "Configure stack options"
6. Under stack creation options, set the timeout to be 5 minutes
    - Default will be 1 hr
    - This is so that in the event the custom resource failed, you don't have to wait 1 hr to delete the stack away
7. Click "Next" to review the stack configurations
8. After selecting the acknowledgement checkbox, click "Submit" 

# Expected Outcome
You should be able to see a random string generated under the `GetRandomString` Key under the "Outputs" section

# Additional notes
As CloudFormation rely on changeset to trigger an update in the stack, you will need to modify the  value of parameter "Length" to be able to trigger an update to rerun the custom resource.
