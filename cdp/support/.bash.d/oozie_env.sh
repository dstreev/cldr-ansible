# Needed when self-signed root used and going to Knox Proxy via SSL
# export TRUST_STORE_FILE=...
# export TRUST_STORE_PASSWORD=...

# Setup for KNOX Proxy with Basic Auth
# export OOZIE_URL="<the knox proxy url>"
# export OOZIE_AUTH=BASIC
# export PROXY_USER=${USER}
# export PROXY_USER_PASSWORD=<pw>

alias ooziejobs='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} jobs -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias ooziejob='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} job -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias oozieadmin='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} admin -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias oozievalidate='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} validate -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias ooziesla='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} sla -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias ooziehive='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} hive -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias ooziesqoop='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} sqoop -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
alias oozieinfo='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} info'
alias ooziemapreduce='oozie -Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD} mapreduce -username=${PROXY_USER} -password=${PROXY_USER_PASSWORD}'
