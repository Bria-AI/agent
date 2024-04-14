resource "terraform_data" "git_clone" {
  triggers_replace = [
  ]
  input = {
    scriptName  = "${path.module}/scripts/gitClone.sh"
    GIT_URL     = var.bria_function_app_git_url
    DESTINATION = "/tmp/agent-functions"
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = format(
      "%s  -u '%s' -d '%s'",
      self.input.scriptName,
      self.input.GIT_URL,
      self.input.DESTINATION
    )
  }
}

data "archive_file" "image_handler" {
  output_path = "/tmp/imageHandler.zip"
  type        = "zip"
  source_dir  = join("/", [terraform_data.git_clone.output.DESTINATION, var.bria_image_function_app_path])
}

data "archive_file" "embedder_handler" {
  output_path = "/tmp/embedderDispatcher.zip"
  type        = "zip"
  source_dir  = join("/", [terraform_data.git_clone.output.DESTINATION, var.bria_embedder_function_app_path])
}

resource "terraform_data" "image_handler_deploy" {
  triggers_replace = [
    data.archive_file.image_handler.output_sha
  ]
  input = {
    scriptName          = "${path.module}/scripts/functionDeploy.sh"
    RESOURCE_GROUP_NAME = module.rg.resource_group_name
    FUNCTION_NAME       = module.image_handler_func.function_app_name
    ZIP_FILE            = data.archive_file.image_handler.output_path
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = format(
      "%s  -g '%s' -n '%s' -z '%s'",
      self.input.scriptName,
      self.input.RESOURCE_GROUP_NAME,
      self.input.FUNCTION_NAME,
      self.input.ZIP_FILE
    )
  }
}

resource "terraform_data" "embedder_dispatcher_deploy" {
  triggers_replace = [
    data.archive_file.embedder_handler.output_sha
  ]
  input = {
    scriptName          = "${path.module}/scripts/functionDeploy.sh"
    RESOURCE_GROUP_NAME = module.rg.resource_group_name
    FUNCTION_NAME       = module.embeddings_dispatcher_func.function_app_name
    ZIP_FILE            = data.archive_file.embedder_handler.output_path
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = format(
      "%s  -g '%s' -n '%s' -z '%s'",
      self.input.scriptName,
      self.input.RESOURCE_GROUP_NAME,
      self.input.FUNCTION_NAME,
      self.input.ZIP_FILE
    )
  }
}