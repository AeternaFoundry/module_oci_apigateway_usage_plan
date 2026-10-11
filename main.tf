resource "oci_apigateway_usage_plan" "apigateway_usage_plans" {
  for_each = var.apigateway_usage_plans

  compartment_id   = each.value.compartment_id
  defined_tags     = each.value.defined_tags
  display_name     = each.value.display_name
  freeform_tags    = each.value.freeform_tags
  is_lock_override = each.value.is_lock_override

  dynamic "entitlements" {
    for_each = each.value.entitlements
    content {
      description = entitlements.value.description
      name        = entitlements.value.name
      dynamic "quota" {
        for_each = entitlements.value.quota != null ? [entitlements.value.quota] : []
        content {
          operation_on_breach = quota.value.operation_on_breach
          reset_policy        = quota.value.reset_policy
          unit                = quota.value.unit
          value               = quota.value.value
        }
      }
      dynamic "rate_limit" {
        for_each = entitlements.value.rate_limit != null ? [entitlements.value.rate_limit] : []
        content {
          unit  = rate_limit.value.unit
          value = rate_limit.value.value
        }
      }
      dynamic "targets" {
        for_each = entitlements.value.targets != null ? entitlements.value.targets : []
        content {
          deployment_id = targets.value.deployment_id
        }
      }
    }
  }

  dynamic "locks" {
    for_each = each.value.locks != null ? each.value.locks : []
    content {
      message = locks.value.message
      type    = locks.value.type
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

