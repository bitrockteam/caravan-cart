terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
    }
    nomad = {
      source = "hashicorp/nomad"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
  required_version = "~> 0.13"
}
