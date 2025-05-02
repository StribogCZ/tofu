resource "example_resource" "example" {
  name        = var.example_name
  description = var.example_description
}

output "example_id" {
  value = example_resource.example.id
}