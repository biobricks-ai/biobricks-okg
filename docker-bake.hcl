group "default" {
  targets = [
    "db-virtuoso-deploy",
  ]
}

variable "REGISTRY" {
  default = ""
}

variable "BUILDER_BASE" {
  default = "docker-image://ubuntu:20.04"
}

variable "RUNTIME_BASE" {
  default = "docker-image://ubuntu:20.04"
}

variable "VIRTUOSO_BASE" {
  default = "docker-image://openlink/virtuoso-opensource-7:latest"
}

target "hdt-cpp" {
  dockerfile = "hdt-cpp/Dockerfile"
  target     = "runtime"
  contexts   = {
    builder-base = "${BUILDER_BASE}"
    runtime-base = "${RUNTIME_BASE}"
  }
}

target "db-virtuoso-deploy" {
  dockerfile = "db-virtuoso/Dockerfile"
  target     = "db"
  contexts   = {
    virtuoso-base  = "${VIRTUOSO_BASE}"
    hdt-cpp        = "target:hdt-cpp"
  }
  tags       = [ "${REGISTRY}db-virtuoso-deploy:latest" ]
}

target "db-virtuoso-deploy-tester" {
  dockerfile = "db-virtuoso/Dockerfile"
  target     = "tester"
  contexts   = {
    db       = "target:db-virtuoso-deploy"
  }
  args       = {
    CACHE_BUST = timestamp()
  }
  output     =  [ "type=cacheonly" ]
}
