# db_backend API key. Never commit the value: supply it at submit time with
#   NOMAD_VAR_db_key=... nomad job run <this file>
# (or -var-file pointing at an uncommitted file).
variable "db_key" {
  type = string
}

job "hyperliquid-s0d-rate-limit" {
  datacenters = ["dc1"]
  type        = "batch"

  periodic {
    cron             = "*/5 * * * *"
    prohibit_overlap = true
    time_zone        = "UTC"
  }

  group "script-group" {
    count = 1

    task "python-script" {
      driver = "raw_exec"

      config {
        command = "/home/admin/anaconda3/bin/python"
        args    = ["/home/admin/prod/hyperliquid-python-sdk/examples/rate_limit_info.py"]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      env {
        DB_KEY = var.db_key
        ACCOUNT = "S0D"
        ADDRESS = "0x8b1c1f4a92d1f07ee440c99833eb96e0d5f62472"
      }
    }
  }
}