# Generates a 2 byte random number that can be appended to the LB name. This avoids naming conflicts.
# By default, this is not used unless specified in `var.name_random`.
resource "random_id" "random" {
  byte_length = 2
}
