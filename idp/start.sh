#! /bin/sh
echo "IDP_HOST: $IDP_HOST"
echo "Updating metadata files..."
sed -i "s#https://pass.local#$IDP_HOST#g" /opt/shibboleth-idp/metadata/idp-metadata.xml
sed -i "s#https://pass.local#$IDP_HOST#g" /opt/shibboleth-idp/metadata/sp-metadata.xml

echo "Starting Jetty"
/usr/local/bin/run-jetty.sh