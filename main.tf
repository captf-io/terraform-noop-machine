# Copyright 2026 The CAPTF Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# No-op machine module: implements the v1alpha1 machine role with no cloud.

# The stand-in for an instance. user_data decodes bootstrap_data the way a
# module feeding a plain user-data argument would, which proves the
# controller's base64 encoding round-trips (the value stays sensitive).
resource "terraform_data" "instance" {
  input = {
    cluster            = var.captf_cluster
    object             = var.captf_object
    machine_name       = var.machine_name
    tags               = var.captf_tags
    backend_id         = try(var.captf_cluster_outputs.backend_id, null)
    user_data          = base64decode(var.bootstrap_data)
    bootstrap_format   = var.bootstrap_format
    failure_domain     = var.failure_domain
    kubernetes_version = var.kubernetes_version
    control_plane      = var.control_plane
  }
}
