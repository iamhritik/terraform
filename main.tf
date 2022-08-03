output "user_names" {
  value = [for name in var.names: upper(name) if length(name) > 4]
}

output "map_user_names" {
  value = {for key,value in var.map_names: upper(key) => upper(value)}
}

output "string_names" {
  value = <<EOF
  %{for name in var.names}
    ${name}
  %{endfor}
  EOF
}

data "template_file" "user_data" {
  count = var.enable_new_user_data ? 0 : 1
  template = file("${path.module}/user-data.sh")
  vars = {
    server_port = 8080
  }
}

data "template_file" "user_data_new" {
  count = var.enable_new_user_data ? 1 : 0
  template = file("${path.module}/userdatanew.sh")
  vars = {
    server_port = 8080
  } 
}

output "user_data_Value" {
 value = length(data.template_file.user_data[*]) > 0 ? data.template_file.user_data[0].rendered: data.template_file.user_data_new[0].rendered
}