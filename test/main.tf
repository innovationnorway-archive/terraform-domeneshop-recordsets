data "domeneshop_domains" "test" {
  domain = var.domain_name
}

module "dns_records" {
  source = "../"

  domeneshop_domain = data.domeneshop_domains.test.domains[0]

  recordsets = [
    {
      name = "foo"
      type = "A"
      ttl  = 3600
      records = [
        "192.0.2.56",
        "192.0.2.57",
      ]
    },
    {
      name = "foo"
      type = "MX"
      ttl  = 3600
      records = [
        "1 foo.example.com.",
        "5 bar.example.com.",
        "5 baz.example.com.",
      ]
    },
    {
      name = "foo"
      type = "TXT"
      ttl  = 3600
      records = [
        "v=spf1 ip4:192.0.2.3 include:foo.example.com -all",
      ]
    },
    {
      name = "_sip._tcp.foo"
      type = "SRV"
      ttl  = 3600
      records = [
        "10 60 5060 foo.example.com.",
        "10 20 5060 bar.example.com.",
        "10 20 5060 baz.example.com.",
      ]
    },
  ]
}

data "dns_a_record_set" "test" {
  host = "foo.${var.domain_name}."
}

data "dns_mx_record_set" "test" {
  domain = "foo.${var.domain_name}."
}

data "dns_txt_record_set" "test" {
  host = "foo.${var.domain_name}."
}

data "dns_srv_record_set" "test" {
  service = "_sip._tcp.foo.${var.domain_name}."
}

data "testing_assertions" "dns_records" {
  subject = "DNS recordsets module"

  equal "a_records" {
    statement = "has expected A records"

    got = toset(data.dns_a_record_set.test.addrs)
    want = toset([
      "192.0.2.56",
      "192.0.2.57",
    ])
  }

  equal "mx_records" {
    statement = "has expected MX records"

    got = toset([
      for rs in data.dns_mx_record_set.test.mx :
      "${rs.preference} ${rs.exchange}"
    ])
    want = toset([
      "1 foo.example.com.",
      "5 bar.example.com.",
      "5 baz.example.com.",
    ])
  }

  equal "txt_records" {
    statement = "has expected TXT records"

    got = toset(data.dns_txt_record_set.test.records)
    want = toset([
      "v=spf1 ip4:192.0.2.3 include:foo.example.com -all"
    ])
  }

  equal "srv_records" {
    statement = "has expected SRV records"

    got = toset([
      for rs in data.dns_srv_record_set.test.srv :
      "${rs.priority} ${rs.weight} ${rs.port} ${rs.target}"
    ])
    want = toset([
      "10 60 5060 foo.example.com.",
      "10 20 5060 bar.example.com.",
      "10 20 5060 baz.example.com.",
    ])
  }
}
