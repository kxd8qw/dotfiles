#!/usr/bin/env bash

# With the addition of Keystone, to use an openstack cloud you should
# authenticate against keystone, which returns a **Token** and **Service
# Catalog**.  The catalog contains the endpoint for all services the
# user/tenant has access to - including nova, glance, keystone, swift.
#
# *NOTE*: Using the 2.0 *auth api* does not mean that compute api is 2.0.  We
# will use the 1.1 *compute api*
export OS_AUTH_URL=http://identity-cis-trcloud.int.thomsonreuters.com:5000/v2.0
export OS_REGION_NAME=${1:-amers1}
[[ $OS_REGION_NAME == noglob || $OS_REGION_NAME == '-h' ]] &&
            export OS_REGION_NAME=amers1

# With the addition of Keystone we have standardized on the term **tenant**
# as the entity that owns the resources.
export OS_TENANT_ID=f4bb208436814698bed2be1d2c1b22de
export OS_TENANT_NAME="DCO - Platform Design and Engineering"

# In addition to the owning entity (tenant), openstack stores the entity
# performing the action as the **user**.
export OS_USERNAME=0087542

# With Keystone you pass the keystone password.
export OS_PASSWORD=disco13dp

# Set nework ID.
export OS_NETID=$(nova network-list | awk '/public/ {print $2}')

help() {
  cat <<-EOF

	DNS domain suffix: ${OS_REGION_NAME}.cis.trcloud

	Set Environment Variables:
	    . $0 [REGION]

	Create server:
	    nova boot --flavor 1 --security-group default --availability-zone \
${OS_REGION_NAME}b \\
	                --image OL-7.1.1-latest --key-name ${OS_USERNAME}-key \
--min 1 --max 1 \\
	                --nic net-id=$OS_NETID ${OS_USERNAME}-stash
	    nova boot --flavor 3 --security-group default --availability-zone \
${OS_REGION_NAME}b \\
	                --image OL-7.1.1-latest --key-name ${OS_USERNAME}-key \
--min 1 --max 1 \\
	                --nic net-id=$OS_NETID ol7-patch-test

	Create a server, a volume, and attach them:
	    nova boot --flavor 3 --security-group default --availability-zone \
${OS_REGION_NAME}b \\
	                --image OL-7.1.1-latest --key-name ${OS_USERNAME}-key \
--min 1 --max 1 \\
	                --nic net-id=$OS_NETID ${OS_USERNAME}-g1
	    cinder create 100 --availability ${OS_REGION_NAME}b --display-name \
${OS_USERNAME}-g1-vol
	    nova volume-attach ${OS_USERNAME}-g1 ${OS_USERNAME}-g1-vol

	Manage Keys:
	    nova keypair-add --pub_key ~/.ssh/id_rsa.pub ${OS_USERNAME}-key
	    nova keypair-list

	EOF
  exit
}

echo "Available regions: amers1 amers2 amers3 apac1 emea1"
echo "Region set to: $OS_REGION_NAME"

for i in "$@"; do [[ "$i" == '-h' ]] && help; done