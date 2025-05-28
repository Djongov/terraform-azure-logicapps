# Name of the resource group, it will be used for placing resources in this group, it might come from the module output or be a string
variable "resource_group_name" {
  description = "Name for the resource group"
  type        = string
  default     = null
}

# Location for the resources, it will be used in naming and tagging of resources
variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "westeurope"
}

# Plays a role in naming and tagging of resources
variable "environment" {
  description = "Environment for the application"
  type        = string
}

# Subscription id for where to deploy the resources
variable "subscription_id" {
  description = "Subscription id"
  type        = string
}

variable "project_name" {
  description = "Project name for the resources, used in tagging"
  type        = string
}

# Repo name
variable "repo_name" {
  description = "repo name that will be used in tagging of resources"
  type        = string
}

# Common tags that will be applied to all resources
variable "common_tags" {
  type    = map(string)
  default = {}
}

# insert your module specific variables here
variable "logic_apps" {
  description = "logic apps map with keys as logic app names and values as logic app configurations"
  type = map(object({
    enabled = optional(bool)
    #triggers = map(any)
    file = string
    api_connection = optional(object({
      managed_api = string
      tags        = optional(map(string), {})
      parameter_values = optional(object({
        token     = optional(map(string))
        tenant_id = string
      }))
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), [])
    }))
    tags = optional(map(string))
  }))
  default = {}
}
