import json

import boto3

from PIL import Image

from io import BytesIO
 
# Initialize the S3 client

s3 = boto3.client('s3')
 
def lambda_handler(event, context):

    # Environment variables for the S3 buckets

    upload_bucket = "your-upload-bucket"  # Replace with your actual bucket name

    processed_bucket = "your-processed-bucket"  # Replace with your processed bucket name
 
    # Get the S3 object from the event (this is the file uploaded to the source S3 bucket)

    record = event['Records'][0]

    bucket_name = record['s3']['bucket']['name']

    object_key = record['s3']['object']['key']
 
    # Download the image from the source bucket

    try:

        response = s3.get_object(Bucket=bucket_name, Key=object_key)

        image_data = response['Body'].read()

    except Exception as e:

        print(f"Error getting object from S3: {e}")

        raise e
 
    # Open the image with Pillow

    try:

        img = Image.open(BytesIO(image_data))
 
        # Resize the image (example: resize to 800x600)

        img_resized = img.resize((800, 600))
 
        # Save the processed image to a BytesIO object

        processed_image_data = BytesIO()

        img_resized.save(processed_image_data, format='JPEG')

        processed_image_data.seek(0)
 
        # Upload the processed image to the processed bucket

        processed_key = f"processed-{object_key}"

        s3.put_object(

            Bucket=processed_bucket,

            Key=processed_key,

            Body=processed_image_data,

            ContentType='image/jpeg'

        )
 
        print(f"Processed image uploaded to {processed_bucket}/{processed_key}")

        return {

            'statusCode': 200,

            'body': json.dumps('Image processed and uploaded successfully')

        }
 
    except Exception as e:

        print(f"Error processing image: {e}")

        raise e

 
