#!/bin/sh

set -e

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT.
if [ -n "$INPUT_AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $INPUT_AWS_S3_ENDPOINT"
fi

# Create a dedicated profile for this action to avoid conflicts
# with past/future actions.
# https://github.com/jakejarvis/s3-cp-action/issues/1
if [ -n "INPUT_AWS_ACCESS_KEY_ID" ]; then
  aws configure --profile s3-cp-action <<-EOF > /dev/null 2>&1
${INPUT_AWS_ACCESS_KEY_ID}
${INPUT_AWS_SECRET_ACCESS_KEY}
${INPUT_AWS_REGION}
text
EOF

# Sync using our dedicated profile and suppress verbose messages.
# All other flags are optional via the `args:` directive.
sh -c "aws s3 cp ${INPUT_SOURCE} ${INPUT_DEST} \
              --no-progress \
              ${ENDPOINT_APPEND} ${INPUT_FLAGS} $*"

