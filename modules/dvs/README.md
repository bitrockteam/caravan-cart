<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13 |

## Providers

| Name | Version |
|------|---------|
| nomad | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [nomad_job](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dc\_names | n/a | `list(string)` | n/a | yes |
| aviation\_edge\_key | n/a | `string` | `""` | no |
| confluent\_platform\_dvs\_enable | Enable Confluent Platform Single Node Job | `bool` | `false` | no |
| cp\_jobs\_constraint | List of constraints to be applied to CP jobs running. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "worker"<br>  }<br>]</pre> | no |
| dvs\_google\_api\_key | n/a | `string` | `""` | no |
| dvs\_http\_url | n/a | `string` | `"https://dvs.$domain"` | no |
| dvs\_ws\_url | n/a | `string` | `"https://dvs.$domain"` | no |
| jobs\_constraint | List of constraints to be applied to jobs running. Escape $ with double $. | `list(map(string))` | <pre>[<br>  {<br>    "attribute": "${meta.nodeType}",<br>    "operator": "=",<br>    "value": "worker"<br>  }<br>]</pre> | no |
| nameserver\_dummy\_ip | n/a | `string` | `"192.168.0.1"` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
