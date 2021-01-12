module "example" {
  source = "../"

  name_prefix = "test"
}

data "testing_assertions" "example" {
  subject = "Example module"

  equal "name_prefix" {
    statement = "has expected name prefix"

    got  = module.example.name_prefix
    want = "test"
  }
}

output "example" {
  value = module.example
}
