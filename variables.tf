variable "domeneshop_domain" {
  type = object({
    id     = string
    domain = string
  })
  description = "The Domeneshop zone to add the records to."
}

variable "recordsets" {
  type = set(object({
    name    = string
    type    = string
    ttl     = number
    records = set(string)
  }))
  description = "Set of DNS record objects to manage, in the standard terraformdns structure."
}
