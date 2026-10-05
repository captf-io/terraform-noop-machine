# terraform-noop-machine

The no-op CAPTF `machine` module: the Terraform/OpenTofu root module behind
`TerraformMachine` that implements the `v1alpha1` machine role and provisions
nothing. Every resource is a `terraform_data` holding its inputs, so plans,
state and outputs are real and no cloud account is needed. Use it to try
CAPTF without a cloud account, to exercise a management cluster, as the
provider's e2e target, or as a starting point for a real module.

The module image `ghcr.io/captf-io/noop-machine` is built and published from
[noop-modules](https://github.com/captf-io/noop-modules); this repository
holds the code and its checks.

## What it returns

`provider_id` `noop:///<namespace>/<machine>`; address `10.0.0.1`; the requested failure domain. It reports `health` as running and healthy.

No machine joins a cluster: the endpoint never resolves and no node
registers, so a Machine reaches `Provisioned` but never gets a `nodeRef`.
The module exercises the provider, not Kubernetes.

## Usage

CAPTF runs this module from the module image `ghcr.io/captf-io/noop-machine`: set the image on
a `TerraformMachine`'s `spec.source.image` (through a `TerraformMachineTemplate`), and the controller renders every
input. The module is also published to the Terraform Registry as
`captf-io/machine/noop` and can be called directly:

```hcl
module "machine" {
  source  = "captf-io/machine/noop"
  version = "~> 0.1"

  # The contract inputs the controller would render (captf_contract,
  # captf_cluster, captf_object, captf_tags, ...; see Inputs), and any
  # user variables.
}
```

It needs no providers and no credentials, which makes it a convenient
fixture for testing a configuration that drives CAPTF modules.

## Development

The host needs make and podman (or docker with `ENGINE=docker`); the
runtimes run in containers pinned by digest. `make verify` is the gate CI
runs.

| Target | What it does |
| --- | --- |
| `fmt` / `fmt-check` | `terraform fmt` and `tofu fmt`, in place or as a check |
| `validate` | `init` and `validate` on Terraform and OpenTofu and on their floors (1.5.7, 1.6.3) |
| `test` | apply, output and destroy `test/root`, which calls the module with every contract input, on each runtime and floor |
| `check-headers` / `fix-headers` | the Apache-2.0 license header on every source file |
| `verify` | all of the above |
| `clean` | remove `build/` |

`RUNTIMES=opentofu` limits a target to one runtime.
