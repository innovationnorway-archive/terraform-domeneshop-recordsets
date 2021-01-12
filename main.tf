resource "random_id" "main" {
  keepers = {
    # Generate a new id each time we change the name prefix
    name_prefix = var.name_prefix
  }

  byte_length = 4
}
