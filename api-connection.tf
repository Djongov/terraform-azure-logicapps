# resource "azurerm_api_connection" "this" {
#   for_each = {
#     for k, v in var.logic_apps : k => v if v.api_connection != null
#   }

#   name                = "${var.project_name}-${each.key}-api-connection"
#   resource_group_name = var.resource_group_name
#   managed_api_id      = local.managed_apis[each.value.api_connection.managed_api].id
#   display_name        = "${var.project_name}-${each.key}-api-connection"

#   parameter_values = {
#     token            = each.value.api_connection.parameter_values.token
#     "token:tenantId" = each.value.api_connection.parameter_values.tenant_id
#   }


#   tags = merge(
#     local.common_tags,
#     each.value.api_connection.tags != null ? each.value.api_connection.tags : {},
#     {
#       "logic-app" = each.key
#     }
#   )

#   lifecycle {
#     # NOTE: since the connectionString is a secure value it's not returned from the API
#     ignore_changes = [parameter_values]
#   }
# }
