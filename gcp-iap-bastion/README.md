# Access to private GKE Endpoint through an internal bastion

This guide explains how you can use Identity-Aware Proxy (IAP) TCP forwarding to enable administrative access to VM instances that do not have external IP addresses or do not permit direct access over the internet.
IAP TCP forwarding allows you to establish an encrypted tunnel over which you can forward SSH, RDP, and other traffic to VM instances. IAP TCP forwarding also provides you fine-grained control over which users are allowed to establish tunnels and which VM instances users are allowed to connect to.
* A special case, establishing an SSH connection using gcloud compute ssh wraps the SSH connection inside HTTPS and forwards it to the remote instance without the need of a listening port on local host.
* TCP forwarding with IAP doesn't require a public, routable IP address assigned to your resource. Instead, it uses internal IPs.

![Alt text](https://github.com/anhbuicsa/gcp-terraform/blob/master/gcp-iap-bastion/images/bastion.png?raw=true "Title")



# I. Provision an internal bastion-host

## Usage

To reduce time to provision a bastion VM, basic usage of this module is as follows:

```hcl
module "iap_bastion" {
  source = "terraform-google-modules/bastion-host/google"

  project = var.project
  zone    = var.zone
  network = google_compute_network.net.self_link
  subnet  = google_compute_subnetwork.net.self_link
  members = [
    "group:devs@example.com",
    "user:me@example.com",
  ]
}
```
For more detail, please refer to: https://github.com/terraform-google-modules/terraform-google-bastion-host/tree/v5.0.0


# II. Allow the bastion-host to access to GKE master
* `roles/compute.osAdminLogin` Grants administrator permissions.

# III. Testing
