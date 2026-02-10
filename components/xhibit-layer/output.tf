output "databrics_group" {
  description = "Databricks group id"
  value       = data.databricks_group.admins
}