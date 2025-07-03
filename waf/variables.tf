variable "blocked_countries" {
  description = "List of ISO country codes to block (e.g., [\"CA\", \"CN\"])"
  type        = list(string)
  default     = ["BD"]
}
