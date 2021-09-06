# This file defines the variables.  They are declared and assigned in the variables.auto.tfvars file. See the variables.auto.tfvars.example as a template.

variable "db_name" {
  type        = string
  default     = ""
}

variable "db_user" {
  type        = string
  default     = ""
}

variable "db_pass" {
  type        = string
  default     = ""
}

variable "wp_locale" {
  type        = string
  default     = ""
}

variable "wp_admin_user" {
  type        = string
  default     = ""
}

variable "wp_admin_pass" {
  type        = string
  default     = ""
}

variable "wp_admin_email" {
  type        = string
  default     = ""
}

variable "wp_title" {
  type        = string
  default     = ""
}