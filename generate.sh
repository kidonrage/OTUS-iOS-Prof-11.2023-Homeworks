#!/bin/sh
MODULE="Modules/NewsapiNetwork/Sources/NewsapiNetwork/"
openapi-generator generate -i "newsapi.yaml" -g swift5 -o "api"
rm -r $MODULE""*
cp -R "api/OpenAPIClient/Classes/OpenAPIs/". $MODULE
rm -r "api"
