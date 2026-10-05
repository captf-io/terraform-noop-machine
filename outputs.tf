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

# Contract outputs of the machine role, v1alpha1.

# Stable per Machine. With no Node behind it, the e2e suite never expects a
# nodeRef; a real module emits the CCM's or kubelet's format (machine.md).
output "provider_id" {
  value = "noop:///${var.captf_object.namespace}/${var.machine_name}"
}

output "addresses" {
  value = [{ type = "InternalIP", address = "10.0.0.1" }]
}

output "failure_domain" {
  value = var.failure_domain
}

output "interruptible" {
  value = false
}

output "health" {
  value = { state = "running", healthy = true, message = null, reasons = [] }
}
