target "docker-metadata-action" {}

variable "APP" {
  default = "litellm-pgvector"
}

// This repo's own release number (upstream has no releases): bump it whenever the
// pinned upstream commit, a patch or constraints.txt changes.
variable "VERSION" {
  default = "0.1.0"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
}

target "image-local" {
  inherits = ["image"]
  output   = ["type=docker"]
  tags     = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits  = ["image"]
  platforms = ["linux/amd64"]
}
