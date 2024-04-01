variable "os_provider" {
  type = object({
    auth_url      = string
    region        = optional(string, "microstack")
    endpoint_type = optional(string, "public")
    insecure      = optional(bool, true)
  })
}
variable "physical_network" {
  type        = string
  description = "Name of the physical network"
}
variable "management_network_name" {
  type        = string
  description = "Name of the management network"
  default     = "management"
}
variable "management_subnet_cidr" {
  type        = string
  description = "CIDR of the management subnet"
  default     = "172.16.1.0/24"
}
