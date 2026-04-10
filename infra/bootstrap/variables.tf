#################################################################

# General Variables

variable "tags" {
  type = map(string)
  default = {
    Project     = "umami"
    Environment = "dev"
  }
}

variable "region" {
  type = string
}