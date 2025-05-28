resource "azurerm_logic_app_workflow" "this" {
  for_each = var.logic_apps

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  enabled             = each.value.enabled != null ? each.value.enabled : true

  parameters = each.value.api_connection.managed_api != null ? {
    "$connections" = jsonencode({
      (each.value.api_connection.managed_api) = {
        connectionId   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Web/connections/${each.value.api_connection.managed_api}"
        connectionName = each.value.api_connection.managed_api
        id             = local.managed_apis[each.value.api_connection.managed_api].id
      }
    })
  } : {}

  workflow_parameters = each.value.api_connection.managed_api != null ? {
    "$connections" = jsonencode({
      defaultValue = {}
      type         = "Object"
    })
  } : {}

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids != null ? identity.value.identity_ids : []
    }
  }


  tags = merge(
    local.common_tags,
    each.value.tags != null ? each.value.tags : {}
  )
}


# resource "azurerm_logic_app_trigger_custom" "this" {
#   for_each = {
#     for logicapp_name, logicapp in var.logic_apps : logicapp_name => {
#       name    = keys(logicapp.triggers)[0]
#       content = values(logicapp.triggers)[0]
#     }
#   }

#   name         = each.value.name
#   logic_app_id = azurerm_logic_app_workflow.this[each.key].id
#   body         = jsonencode(each.value.content)
# }

resource "azurerm_logic_app_trigger_custom" "this" {
  for_each = local.logic_app_trigger_map

  name         = each.value.trigger_name
  logic_app_id = azurerm_logic_app_workflow.this[each.value.app_name].id

  body = jsonencode(each.value.content)
}

resource "azurerm_logic_app_action_custom" "actions" {
  for_each = local.logic_app_action_map

  name         = each.value.action_name
  logic_app_id = azurerm_logic_app_workflow.this[each.value.app_name].id

  body = jsonencode(each.value.content)
}
