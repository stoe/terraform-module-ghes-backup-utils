variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = "ghes-backup-utils"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC to assign the resource to"
  default     = ""
}

variable "public_key_path" {
  description = "The path to the public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "backup_utils_region" {
  description = "The AWS region"
  default     = ""
}

variable "backup_utils_az" {
  description = "The availability zones in the region"
  default     = ""
}

variable "backup_utils_instance_type" {
  description = "(Optional) The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance"
  default     = "t2.micro"
}

variable "backup_utils_volume_size" {
  description = "(Optional) The size of the drive in GiBs. See: https://git.io/fjJTR#storage-requirements"
  default     = 8
}
