resource "shoreline_notebook" "site_unreachable_via_ingress_resource_on_kubernetes" {
  name       = "site_unreachable_via_ingress_resource_on_kubernetes"
  data       = file("${path.module}/data/site_unreachable_via_ingress_resource_on_kubernetes.json")
  depends_on = [shoreline_action.invoke_check_website_connectivity,shoreline_action.invoke_ingress_verification,shoreline_action.invoke_update_ingress_backend]
}

resource "shoreline_file" "check_website_connectivity" {
  name             = "check_website_connectivity"
  input_file       = "${path.module}/data/check_website_connectivity.sh"
  md5              = filemd5("${path.module}/data/check_website_connectivity.sh")
  description      = "Check the connectivity to website"
  destination_path = "/tmp/check_website_connectivity.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ingress_verification" {
  name             = "ingress_verification"
  input_file       = "${path.module}/data/ingress_verification.sh"
  md5              = filemd5("${path.module}/data/ingress_verification.sh")
  description      = "Check the ingress configuration settings to ensure that they are properly set up and routing traffic to the correct destination."
  destination_path = "/tmp/ingress_verification.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_ingress_backend" {
  name             = "update_ingress_backend"
  input_file       = "${path.module}/data/update_ingress_backend.sh"
  md5              = filemd5("${path.module}/data/update_ingress_backend.sh")
  description      = "Check the created ingress resources and verify that they are properly configured to route traffic to the intended service and port."
  destination_path = "/tmp/update_ingress_backend.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_website_connectivity" {
  name        = "invoke_check_website_connectivity"
  description = "Check the connectivity to website"
  command     = "`chmod +x /tmp/check_website_connectivity.sh && /tmp/check_website_connectivity.sh`"
  params      = []
  file_deps   = ["check_website_connectivity"]
  enabled     = true
  depends_on  = [shoreline_file.check_website_connectivity]
}

resource "shoreline_action" "invoke_ingress_verification" {
  name        = "invoke_ingress_verification"
  description = "Check the ingress configuration settings to ensure that they are properly set up and routing traffic to the correct destination."
  command     = "`chmod +x /tmp/ingress_verification.sh && /tmp/ingress_verification.sh`"
  params      = ["SERVICE_NAME","INGRESS_NAME","NAMESPACE"]
  file_deps   = ["ingress_verification"]
  enabled     = true
  depends_on  = [shoreline_file.ingress_verification]
}

resource "shoreline_action" "invoke_update_ingress_backend" {
  name        = "invoke_update_ingress_backend"
  description = "Check the created ingress resources and verify that they are properly configured to route traffic to the intended service and port."
  command     = "`chmod +x /tmp/update_ingress_backend.sh && /tmp/update_ingress_backend.sh`"
  params      = ["BACKEND_PORT","INGRESS_NAME","NAMESPACE","BACKEND_SERVICE"]
  file_deps   = ["update_ingress_backend"]
  enabled     = true
  depends_on  = [shoreline_file.update_ingress_backend]
}

