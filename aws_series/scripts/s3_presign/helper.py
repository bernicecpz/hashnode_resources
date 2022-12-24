
import argparse, sys
import requests
import boto3

class S3Helper:
    def __init__(self):
        self.client = boto3.client('s3')

    def generate_presign_url(self, bucket, bucket_key, client_method, expires_in=60):
        # Common method to generate the presigned url where the operation is set via the Client Method
        url = self.client.generate_presigned_url(
            ClientMethod = f'{client_method}',
            Params = {
                'Bucket': f'{bucket}',
                'Key': f'{bucket_key}'
            },
            ExpiresIn=f'{expires_in}'
        )
        return url
    
    def upload_file(self, filepath, upload_url):
        # Retrieve the target file from local machine to read the binary and upload to S3
        try:
            with open(filepath, 'r') as object_file:
                object_text = object_file.read()
                response = requests.put(upload_url, data=object_text)
                print(f'PUT Operation Status Code: {response.status_code}')
                
        except FileNotFoundError:
            print(f"Couldn't find {filepath}. For a PUT operation, the key must be the name of a file that exists on your computer.")

    def delete_file(self, delete_url):
        # Send a request to delete the target file from S3 with generated URL
        response = requests.delete(delete_url)
        print(f'DELETE Operation Status Code: {response.status_code}')

# Remove default action groups
parser = argparse.ArgumentParser()
parser._action_groups.pop()

# Define custom argument groups
required = parser.add_argument_group('Required arguments')
options = parser.add_argument_group('Options to pass when generating S3 presigned URL')

required.add_argument('-a','--action', choices=['get','put','delete'], help='Type of S3 presigned URL to generate',required=True)
required.add_argument('-b', '--bucket', help='Bucket name', required=True)
required.add_argument('-k', '--key', help='Bucket key, i.e. the filename or path to file')

options.add_argument('-e', '--expires', help='Define url to expire in seconds', default=60)
options.add_argument('-f', '--uploadfile', help='File to upload')

args = parser.parse_args()

try:
    s3_helper = S3Helper()
    url = s3_helper.generate_presign_url(args.bucket,args.key, f'{args.action}_object', args.expires)

    if args.action == 'get':
        if args.key is not None:
            print(f'S3 Presigned URL (GET): {url}')
        else:
            print(f'Please provide the path (-k | --key) to retrieve the file from S3')

    elif args.action == 'put':
        if args.key is not None and  args.uploadfile is not None:
            print(f'S3 Presigned URL (PUT): {url}')
            print(f'S3 Presigned URL (PUT) not meant to be used interactively')
            s3_helper.upload_file(args.uploadfile, url)
        else:
            print(f'Please provide the file to upload (-f | --uploadfile) and (-k | --key) the name to save the file as in S3')

    elif args.action == 'delete':
        if args.key is not None:
            print(f'S3 Presigned URL (DELETE): {url}')
            print(f'S3 Presigned URL (DELETE) not meant to be used interactively')
            s3_helper.delete_file(url)
        else:
            print(f'Please provide the path (-k | --key) to retrieve the file from S3')

except Exception as err:
    print(f'Please ensure you have provided the appropriate parameters for the actions.')
    print(f'Error - {type(err).__name__}:{err}\n')
    sys.exit(1)