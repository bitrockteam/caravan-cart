<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nomad"></a> [nomad](#provider\_nomad) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [nomad_job.confluent_platform_dvs](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) | resource |
| [nomad_job.dvs](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dc_names"></a> [dc\_names](#input\_dc\_names) | n/a | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_aviation_edge_key"></a> [aviation\_edge\_key](#input\_aviation\_edge\_key) | n/a | `string` | `""` | no |
| <a name="input_confluent_platform_dvs_enable"></a> [confluent\_platform\_dvs\_enable](#input\_confluent\_platform\_dvs\_enable) | Enable Confluent Platform Single Node Job | `bool` | `false` | no |
| <a name="input_cp_jobs_constraint"></a> [cp\_jobs\_constraint](#input\_cp\_jobs\_constraint) | List of constraints to be applied to CP jobs running. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "worker"<br>  }<br>]</pre> | no |
| <a name="input_dvs_google_api_key"></a> [dvs\_google\_api\_key](#input\_dvs\_google\_api\_key) | n/a | `string` | `""` | no |
| <a name="input_jobs_constraint"></a> [jobs\_constraint](#input\_jobs\_constraint) | List of constraints to be applied to jobs running. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "worker"<br>  }<br>]</pre> | no |
| <a name="input_nameserver_dummy_ip"></a> [nameserver\_dummy\_ip](#input\_nameserver\_dummy\_ip) | n/a | `string` | `"192.168.0.1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
