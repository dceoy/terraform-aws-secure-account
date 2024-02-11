resource "aws_s3control_storage_lens_configuration" "main" {
  config_id  = "${var.system_name}-${var.env_type}-s3-storage-lens-configuration"
  account_id = local.account_id
  storage_lens_configuration {
    enabled = true
    account_level {
      activity_metrics {
        enabled = true
      }
      advanced_cost_optimization_metrics {
        enabled = true
      }
      advanced_data_protection_metrics {
        enabled = true
      }
      detailed_status_code_metrics {
        enabled = true
      }
      bucket_level {
        activity_metrics {
          enabled = true
        }
        advanced_cost_optimization_metrics {
          enabled = true
        }
        advanced_data_protection_metrics {
          enabled = true
        }
        detailed_status_code_metrics {
          enabled = true
        }
        prefix_level {
          storage_metrics {
            enabled = true
          }
        }
      }
    }
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-s3-storage-lens-configuration"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
