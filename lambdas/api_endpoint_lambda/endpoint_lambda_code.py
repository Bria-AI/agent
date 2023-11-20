import json

def handler(event, context):
    # Sample processing logic
    # Replace this with your actual image generation logic
    image_url = "https://example.com/generated-image.png"

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Image generated successfully",
            "imageUrl": image_url
        })
    }
