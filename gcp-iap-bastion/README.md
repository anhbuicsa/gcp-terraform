# Access to private GKE Endpoint through an internal bastion

This guide explains how you can use Identity-Aware Proxy (IAP) TCP forwarding to enable administrative access to VM instances that do not have external IP addresses or do not permit direct access over the internet.
IAP TCP forwarding allows you to establish an encrypted tunnel over which you can forward SSH, RDP, and other traffic to VM instances. IAP TCP forwarding also provides you fine-grained control over which users are allowed to establish tunnels and which VM instances users are allowed to connect to.

### terraform-google-bastion-host


Basic usage of this module is as follows: https://registry.terraform.io/modules/terraform-google-modules/bastion-host/google/latest/submodules/iap-tunneling


```hcl
module "iap_tunneling" {
  source = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"

  project                    = var.project
  network                    = var.network
  service_accounts           = [var.service_account_email]

  instances = [{
    name = var.vm1_name
    zone = var.vm1_zone
  }]

  members = [
    "group:devs@example.com",
    "user:me@example.com",
  ]
}
```
Once the firewall rule is created, you can search for the newly created firewall rule with something similar to the following:
```
gcloud compute firewall-rules list --project my-project --filter="name=allow-ssh-from-iap-to-tunnel"
```
Once the IAM bindings for IAP-secured Tunnel User is created, you can verify them with something similar to the following:

```
$ curl -H "Authorization: Bearer $(gcloud auth print-access-token)" -X POST \
https://iap.googleapis.com/v1/projects/my-project/iap_tunnel/zones/us-central1-a/instances/my-instance:getIamPolicy
{
  "bindings": [
    {
      "role": "roles/iap.tunnelResourceAccessor",
      "members": [
        "user:me@example.com"
      ]
    }
  ]
}
```