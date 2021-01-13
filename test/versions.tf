terraform {
  required_version = ">= 0.13"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.0.0"
    }
    domeneshop = {
      source  = "innovationnorway/domeneshop"
      version = ">= 0.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.6.0"
    }
    testing = {
      source  = "apparentlymart/testing"
      version = ">= 0.0.2"
    }
  }
}
