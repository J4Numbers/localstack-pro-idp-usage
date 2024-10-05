#!/usr/bin/env bash

CLIENT_ID="$1"
CLIENT_SECRET="$2"

CREATED_POOL=$(aws --endpoint http://localhost:4566 cognito-idp create-user-pool --pool-name "exemplar-pool")

POOL_ID=$(echo "${CREATED_POOL}" | jq -r ".UserPool.Id")

echo "Created pool: ${POOL_ID}"

PROVIDER_DETAILS="{
  \"attributes_request_method\": \"GET\",
  \"authorize_scopes\": \"email profile openid\",
  \"client_id\": \"${CLIENT_ID}\",
  \"client_secret\": \"${CLIENT_SECRET}\",
  \"oidc_issuer\": \"http://keycloak.local:8080/realms/master\",
  \"attributes_url\": \"http://keycloak.local:8080/realms/master/protocol/openid-connect/userInfo\",
  \"authorize_url\": \"http://localhost:8080/realms/master/protocol/openid-connect/auth\",
  \"token_url\": \"http://keycloak.local:8080/realms/master/protocol/openid-connect/token\",
  \"jwks_uri\": \"http://keycloak.local:8080/realms/master/protocol/openid-connect/certs\"
}"

aws --endpoint http://localhost:4566 cognito-idp create-identity-provider --user-pool-id "${POOL_ID}" --provider-name "${CLIENT_ID}" --provider-type "OIDC" --provider-details "${PROVIDER_DETAILS}"

aws --endpoint http://localhost:4566 cognito-idp create-user-pool-client --user-pool-id "${POOL_ID}" --client-name "demo-app" --generate-secret --supported-identity-providers "${CLIENT_ID}"
