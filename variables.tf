variable "usernames" {
    description = "IAM Users"
    type = list(string)
    default = ["hritik", "asmath"]
}

variable "custom_tags" {
    type = map(string)
    default = {
        Name = "hritik"
        Name = "asmath"
        Name = "demo"
        Name = "test"
        Name = "hola"
    }
}