variable "apigateway_usage_plans" {
  description = <<EOT
Map of apigateway_usage_plans, attributes below
Required:
    - compartment_id
    - entitlements (block):
        - description (optional)
        - name (required)
        - quota (optional, block):
            - operation_on_breach (required)
            - reset_policy (required)
            - unit (required)
            - value (required)
        - rate_limit (optional, block):
            - unit (required)
            - value (required)
        - targets (optional, block):
            - deployment_id (required)
Optional:
    - defined_tags
    - display_name
    - freeform_tags
    - is_lock_override
    - locks (block):
        - message (optional)
        - type (required)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id   = string
    defined_tags     = optional(map(string))
    display_name     = optional(string)
    freeform_tags    = optional(map(string))
    is_lock_override = optional(bool)
    entitlements = list(object({
      description = optional(string)
      name        = string
      quota = optional(object({
        operation_on_breach = string
        reset_policy        = string
        unit                = string
        value               = number
      }))
      rate_limit = optional(object({
        unit  = string
        value = number
      }))
      targets = optional(list(object({
        deployment_id = string
      })))
    }))
    locks = optional(list(object({
      message = optional(string)
      type    = string
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.apigateway_usage_plans : (
        length(v.entitlements) >= 1
      )
    ])
    error_message = "Each entitlements list must contain at least 1 items"
  }
}

