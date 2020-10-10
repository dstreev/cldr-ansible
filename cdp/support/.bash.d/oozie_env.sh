# Needed when self-signed root used and going to Knox Proxy via SSL
# export TRUST_STORE_FILE=...
# export TRUST_STORE_PASSWORD=...

# Setup for KNOX Proxy with Basic Auth
# export OOZIE_URL="<the knox proxy url>"
# export KNOX_PROXY_USER=${USER}
# export KNOX_PROXY_USER_PASSWORD=<pw>

export OOZIE_AUTH=BASIC

export OOZIE_CLIENT_OPTS="-Djavax.net.ssl.trustStore=${TRUST_STORE_FILE} -Djavax.net.ssl.trustStorePassword=${TRUST_STORE_PASSWORD}"

alias ooziejobs='oozie jobs -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias ooziejob='oozie job -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias oozieadmin='oozie admin -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias oozievalidate='oozie validate -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias ooziesla='oozie sla -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias ooziehive='oozie hive -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias ooziesqoop='oozie sqoop -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
alias ooziemapreduce='oozie mapreduce -username=${KNOX_PROXY_USER} -password=${KNOX_PROXY_USER_PASSWORD}'
