# vpn-configuration-examples

Examples for configuring VPNs, for connecting to BYOC deployed applications.

## Azure-to-AWS

To setup a point to point connection from an Azure VPN to an AWS VPC, please refer to the terraform code in the [azure](./azure-to-aws) directory.

To create a connection, you can add the following inputs into this terraform:

* `aws_gw_address` - the address of the AWS gateway.
* `aws_address_space` - the aws address space via the gateway.
* `shared_key` - the shared key from the AWS gateway.
* `name` - the name for the vnet and resource group.
* `location` - the location to create this in.

You can add these parameters to a `terraform.tfvars` file and run `terraform apply`. Please make sure to setup
environment variables to authenticate your environment with Azure.
