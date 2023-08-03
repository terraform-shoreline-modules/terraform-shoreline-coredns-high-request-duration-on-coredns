resource "shoreline_notebook" "high_request_duration_on_coredns" {
  name       = "high_request_duration_on_coredns"
  data       = file("${path.module}/data/high_request_duration_on_coredns.json")
  depends_on = []
}

