target "docker-metadata-action" {}

variable "APP" {
  default = "talosctl-busybox"
}

variable "VERSION" {
  // renovate: datasource=docker depName=ghcr.io/siderolabs/talosctl
  default = "v1.14.5"
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
  platforms = ["linux/amd64", "linux/arm64"]
}
