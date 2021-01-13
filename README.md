![test](https://github.com/innovationnorway/terraform-domeneshop-recordsets/workflows/test/badge.svg)

# Domeneshop DNS Recordsets Module

This module manages DNS recordsets in a given Domeneshop domain. It follows the structure of [the `terraformdns` project](https://terraformdns.github.io/).

## Example Usage

```hcl
data "domeneshop_domains" "example" {
  domain = "example.com"
}

module "dns_records" {
  source = "innovationnorway/recordsets/domeneshop"

  domeneshop_domain = data.domeneshop_domains.example.domains[0]

  recordsets = [
    {
      name = "www"
      type = "A"
      ttl  = 3600
      records = [
        "192.0.2.56",
      ]
    },
    {
      name = "@"
      type = "MX"
      ttl  = 3600
      records = [
        "1 mail1",
        "5 mail2",
        "5 mail3",
      ]
    },
    {
      name = "@"
      type = "TXT"
      ttl  = 3600
      records = [
        "v=spf1 ip4:192.0.2.3 include:${data.domeneshop_domains.example.domains[0].domain} -all",
      ]
    },
    {
      name = "_sip._tcp"
      type = "SRV"
      ttl  = 3600
      records = [
        "10 60 5060 sip1",
        "10 20 5060 sip2",
        "10 20 5060 sip3",
      ]
    },
  ]
}
```

## Arguments

- `domeneshop_domain` is the domain to add records to. The easiest way to populate this is to assign an existing `data.domeneshop_domain` or `data.domeneshop_domains` resource directly, though at minimum it requires only an object with `id` and `domain` attributes.
- `recordsets` is a list of DNS recordsets in the standard `terraformdns` recordset format.

## Limitations

This module currently supports the following DNS record types:

* `A`
* `AAAA`
* `ANAME`
* `CNAME`
* `MX`
* `NS`
* `SRV`
* `TXT`

If you need to use other record types, use the `domeneshop_record` resource directly.
