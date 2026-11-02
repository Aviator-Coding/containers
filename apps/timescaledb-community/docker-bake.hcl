target "docker-metadata-action" {}

variable "APP" {
  default = "timescaledb-community"
}

// Exact Debian package version; the image tag is the part before `~` (2.31.0).
variable "VERSION" {
  // renovate: datasource=deb depName=timescaledb-2-postgresql-18
  default = "2.31.0~debian13-1806"
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
