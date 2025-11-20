#! /bin/bash

AAP_HOSTNAME=<AAP_HOSTNAME>
AAP_TOKEN=<AAP_TOKEN>
AAP_JOB_TEMPLATE_NAME="Lab%20simple%20demo"
AAP_EXTRA_VARS=$(cat << EOF
{
  "my_variable": "test from curl"
}
EOF
)

set -x

AAP_JOB_TEMPLATE_ID=$(curl -X GET \
  -H "Authorization: Bearer ${AAP_TOKEN}" \
  "https://${AAP_HOSTNAME}/api/controller/v2/job_templates/?name=${AAP_JOB_TEMPLATE_NAME}" | jq '.results[0].id'
)
if [ "$?" != 0 ]
then
  echo something went wrong
  exit 1
fi

echo INFO: Job template ID for "${AAP_JOB_TEMPLATE_NAME}" is "${AAP_JOB_TEMPLATE_ID}"


curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${AAP_TOKEN}" \
  -d "{\"extra_vars\": ${AAP_EXTRA_VARS}}" \
  "https://${AAP_HOSTNAME}/api/controller/v2/job_templates/${AAP_JOB_TEMPLATE_ID}/launch/" | jq '{id, url}'
if [ "$?" != 0 ]
then
  echo something went wrong
  exit 1
fi
