variable "REGISTRY" {
  default = "ghcr.io/m-s-software-engineering-ag"
}

# renovate: datasource=github-releases depName=traefik/traefik
variable "TRAEFIK_VERSION" {
  default = "v3.7.17"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/container-supervisor
variable "SUPERVISOR_VERSION" {
  default = "v1.10.1"
}

# renovate: datasource=github-releases depName=maxlerebourg/crowdsec-bouncer-traefik-plugin
variable "CROWDSEC_PLUGIN_VERSION" {
  default = "v1.7.1"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/envelope
variable "ENVELOPE_VERSION" {
  default = "v1.1.2"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/container-healthcheck
variable "HEALTHCHECK_VERSION" {
  default = "v1.0.0"
}

variable "IMAGE_REVISION" {
  default = "6.1"
}

group "default" {
  targets = ["traefik", "traefik-debug"]
}

target "traefik" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "final"
  args       = {
    TRAEFIK_VERSION         = TRAEFIK_VERSION
    SUPERVISOR_VERSION      = SUPERVISOR_VERSION
    CROWDSEC_PLUGIN_VERSION = CROWDSEC_PLUGIN_VERSION
    ENVELOPE_VERSION        = ENVELOPE_VERSION
    HEALTHCHECK_VERSION     = HEALTHCHECK_VERSION
  }
  tags       = [
    "${REGISTRY}/rootless-containers-traefik:${TRAEFIK_VERSION}-${IMAGE_REVISION}",
    "${REGISTRY}/rootless-containers-traefik:${TRAEFIK_VERSION}-${regex_replace(IMAGE_REVISION, "\\.[0-9]+$", "")}",
    "${REGISTRY}/rootless-containers-traefik:latest",
  ]
  platforms  = [
    "linux/amd64",
    "linux/arm64",
    "linux/arm/v7",
  ]
}

target "traefik-debug" {
  inherits = ["traefik"]
  target   = "debug"
  tags     = [
    "${REGISTRY}/rootless-containers-traefik:${TRAEFIK_VERSION}-${IMAGE_REVISION}-debug",
    "${REGISTRY}/rootless-containers-traefik:${TRAEFIK_VERSION}-${regex_replace(IMAGE_REVISION, "\\.[0-9]+$", "")}-debug",
    "${REGISTRY}/rootless-containers-traefik:latest-debug",
  ]
}
