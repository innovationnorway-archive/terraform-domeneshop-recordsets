variable "name_prefix" {
  type        = string
  description = "Creates a unique name beginning with the specified prefix."

  validation {
    condition     = can(regex("^[a-z0-9-]{3,12}$", var.name_prefix))
    error_message = "The name_prefix value must be between 3 and 12 characters in length and use numbers, hyphen and lower-case letters only."
  }
}
