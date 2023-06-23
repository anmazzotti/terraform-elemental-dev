# terraform-elemental-dev

A Terraform plan to bootstrap an [Elemental Teal](https://elemental.docs.rancher.com/) development environment

This plan can be used to deploy the following resources:

- A virtual machine running [Rancher](https://www.rancher.com/) with the latest version of the [elemental-operator](https://github.com/rancher/elemental-operator) and [elemental plugin](https://github.com/rancher/elemental-ui) installed.
- An empty virtual machine running [MicroOS](https://microos.opensuse.org/) with the latest version of [elemental-toolkit](https://github.com/rancher/elemental-toolkit) installed, Golang and all needed tools to contribute to Elemental development.
- N virtual machines that can be boostrapped with the [Elemental SeedImage](https://elemental.docs.rancher.com/seedimage-reference) to form a cluster.

## Usage

```shell
terraform init
terraform plan
terraform apply
```

### Configure host DNS

```shell
sudo echo "172.16.0.10     rancher.rancher.local" >> /etc/hosts
```

### Access VMs

All VMs can be accessed with `root:rancher` credentials through SSH.

### Accessing Rancher

Once the setup is done (may take a few minutes depending on your system), you can login into the Rancher dashboard with `admin:rancher` credentials at: [https://rancher.rancher.local](https://rancher.rancher.local)
