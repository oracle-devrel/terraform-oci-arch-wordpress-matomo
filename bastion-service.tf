## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_bastion_bastion" "bastion_service" {
  bastion_type                 = "STANDARD"
  compartment_id               = var.compartment_ocid
  target_subnet_id             = oci_core_subnet.private.id
  client_cidr_block_allow_list = ["0.0.0.0/0"]
  name                         = "BastionService4MySQLVM"
  max_session_ttl_in_seconds   = 10800
}

resource "oci_bastion_session" "ssh_via_bastion_service" {
  bastion_id = oci_bastion_bastion.bastion_service.id 

  key_details {
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }

  target_resource_details {
    session_type                               = "MANAGED_SSH"
    target_resource_id                         = oci_core_instance.MySQLinstance.id
    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = 22
    target_resource_private_ip_address         = oci_core_instance.MySQLinstance.private_ip
  }

  display_name           = "ssh_via_bastion_service_to_mysqlvm"
  key_type               = "PUB"
  session_ttl_in_seconds = 10800
}