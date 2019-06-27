# EKSTerraformSpinup

This Terraform script brings up an eks cluster.

when using this script make sure to register the nodes that are created with a config map.

Failure to register the nodes with kubernetes will cause all containers to fail.

Use `kubectl apply -f {path_to_kubeconfig_generated_by_output_from_terraform}` to confire kubectl to the cluster created

Then to configuure the nodes use:

`kubctl apply -f {path_to_configmap_generated_by_output_from_terraform}`
