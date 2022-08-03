variable "names" {
  description = "list of names"
  type = list(string)
  default = ["hritik","pola","gola"]
}

variable "map_names" {
    type = map(string)
    default = {
        neo = "peo"
        hola = "pola"
        gola = "mola"
    }
}

variable "enable_new_user_data" {
    description = "if true; then new user_data used"
    type = bool
}