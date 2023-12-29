terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.53.0"
    }
    grafana = {
      source = "grafana/grafana"
      version = "2.8.0"
    }
    kibana = {
      source = "disaster37/kibana"
      version = "8.5.3"
    }
  }
}
