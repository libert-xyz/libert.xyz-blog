
#!/bin/bash
set -e

# Run this in your Hugo blog repo directory

# These are mine. They won't work for you :)
DISTRIBUTION_ID=E8AJ22DZBJEDR
BUCKET_NAME=libert.xyz-blog-cdn
PROFILE=default

hugo -v

# Copy over pages - not static js/img/css/downloads
aws s3 sync --profile ${PROFILE} --acl "public-read" --sse "AES256" public/ s3://${BUCKET_NAME}/ --exclude 'images' --exclude 'less' --exclude 'js' --exclude 'downloads' --exclude 'css' --exclude 'post'
#aws s3 sync --profile ${PROFILE} --acl "public-read" --sse "AES256" public/ s3://${BUCKET_NAME}/


# Ensure static files are set to cache forever - cache for a month --cache-control "max-age=2592000"
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/images/ s3://${BUCKET_NAME}/images/
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/css/ s3://${BUCKET_NAME}/css/
aws s3 sync --profile ${PROFILE} --cache-control "max-age=2592000" --acl "public-read" --sse "AES256" public/less/ s3://${BUCKET_NAME}/less/

# Downloads binaries, not part of repo - cache at edge for a year --cache-control "max-age=31536000"
#aws s3 sync --profile ${PROFILE} --cache-control "max-age=31536000" --acl "public-read" --sse "AES256"  static/downloads/ s3://${BUCKET_NAME}/downloads/

# Invalidate landing page so everything sees new post - warning, first 1K/mo free, then 1/2 cent each
aws cloudfront create-invalidation --profile ${PROFILE} --distribution-id ${DISTRIBUTION_ID} --paths /index.html /
