# Script to generate S3 presigned url

## Prerequisites
1. Ensure you have configured the AWS programmatic access on your local machine

2. Setup to use the scripts
```shell
# Create virtualenv
python3 -m venv <virtual_env_name>
. <virtual_env_name>/bin/activate

# Install modules
pip3 install -r requirements.txt
```

# Usage

## Help Option
```
% python3 helper.py -h
usage: helper.py [-h] -a {get,put,delete} -b BUCKET [-k KEY] [-e EXPIRES] [-f UPLOADFILE]

Required arguments:
  -a {get,put,delete}, --action {get,put,delete}
                        Type of S3 presigned URL to generate
  -b BUCKET, --bucket BUCKET
                        Bucket name
  -k KEY, --key KEY     Bucket key, i.e. the filename or path to file

Options to pass when generating S3 presigned URL:
  -e EXPIRES, --expires EXPIRES
                        Define url to expire in seconds
  -f UPLOADFILE, --uploadfile UPLOADFILE
                        File to upload
```

## Sharing Object (GET)

```
python3 helper.py -a get -b <BUCKET_NAME> -k <BUCKET_KEY> [ -e SECONDS ]
``` 

## Uploading Object (PUT)
Note that the BUCKET_KEY will be the intended filename to save the file as in the S3 bucket
```
python3 helper.py -a put -b <BUCKET_NAME> -k <BUCKET_KEY> -f <LOCAL_FILEPATH_TO_FILE> [ -e SECONDS ]
```

## Deleting Object (DELETE)
```
python3 helper.py -a delete -b <BUCKET_NAME> -k <BUCKET_KEY> [-e SECONDS ]
```