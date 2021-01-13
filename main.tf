locals {
  # The Domeneshop provider works in terms of records rather than recordsets, so
  # we'll need to flatten first.
  records = flatten([
    for rs in var.recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
  pattern = "^(?:(?P<priority>\\d*) )?(?:(?P<weight>\\d*) )?(?:(?P<port>\\d*) )?(?:(?P<host>.*))?"
}

resource "domeneshop_record" "main" {
  for_each = {
    for r in local.records : "${r.name}:${r.type}:${r.data}" => r
  }

  domain_id = var.domeneshop_domain.id

  host = coalesce(each.value.name, "@")
  type = each.value.type
  data = (
    contains(["MX", "SRV"], each.value.type) ?
    regex(local.pattern, each.value.data).host :
    each.value.data
  )
  ttl = each.value.ttl
  priority = (
    contains(["MX", "SRV"], each.value.type) ?
    regex(local.pattern, each.value.data).priority :
    null
  )
  weight = (
    each.value.type == "SRV" ?
    regex(local.pattern, each.value.data).weight :
    null
  )
  port = (
    each.value.type == "SRV" ?
    regex(local.pattern, each.value.data).port :
    null
  )
}
