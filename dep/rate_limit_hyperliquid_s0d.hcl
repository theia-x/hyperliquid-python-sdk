# DATABASE_KEY comes from BWS (project "common") at run time via
# with-database-key.sh; it is never in this file or the job env.
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
        command = "/bin/bash"
        args    = ["/home/admin/prod/hyperliquid-python-sdk/dep/with-database-key.sh", "/home/admin/anaconda3/bin/python", "/home/admin/prod/hyperliquid-python-sdk/examples/rate_limit_info.py"]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      env {
        ACCOUNT = "S0D"
        ADDRESS = "0x8b1c1f4a92d1f07ee440c99833eb96e0d5f62472"
      }
    }
  }
}