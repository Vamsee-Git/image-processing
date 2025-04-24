import json
import boto3
from PIL import Image
import io

s3 = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    dest_bucket = 'processed-images-bucket-vamsee'

    # Get the image from S3
    response = s3.get_object(Bucket=source_bucket, Key=key)
    image_content = response['Body'].read()

    # Process the image
    image = Image.open(io.BytesIO(image_content))
    image = image.resize((100, 100))  # Example resizing

    # Save the processed image to a new S3 bucket
    buffer = io.BytesIO()
    image.save(buffer, 'JPEG')
    buffer.seek(0)

    s3.put_object(Bucket=dest_bucket, Key=key, Body=buffer, ContentType='image/jpeg')

    return {
        'statusCode': 200,
        'body': json.dumps('Image processed and uploaded successfully!')
    }

