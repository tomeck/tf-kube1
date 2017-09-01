# Configure the IBM Cloud Provider
provider "ibm" {
  bluemix_api_key    = "${var.ibm_bmx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
}

# Create an SSH key. The SSH key surfaces in the SoftLayer console under Devices > Manage > SSH Keys.
resource "ibm_compute_ssh_key" "test_key_1" {
  label      = "test_key_1"
  public_key = "${file(\"~/.ssh/id_rsa_test_key_1.pub\")}"

  # Windows example:
  # public_key = "${file(\"C:\ssh\keys\path\id_rsa_test_key_1.pub\")}"
}

# Create a virtual server with the SSH key.
resource "ibm_compute_vm_instance" "my_server_2" {
  hostname          = "host-b.example.com"
  domain            = "example.com"
  ssh_keys          = [123456, "${ibm_compute_ssh_key.test_key_1.id}"]
  os_reference_code = "CENTOS_6_64"
  datacenter        = "ams01"
  network_speed     = 10
  cores             = 1
  memory            = 1024
}

# Read details of IBM Bluemix Space
data "ibm_space" "space" {
  space = "${var.space}"
  org   = "${var.org}"
}

# Create an instance of a IBM service.
resource "ibm_service_instance" "service" {
  name       = "${var.instance_name}"
  space_guid = "${data.ibm_space.space.id}"
  service    = "cleardb"
  plan       = "cb5"
  tags       = ["cluster-service", "cluster-bind"]
}
