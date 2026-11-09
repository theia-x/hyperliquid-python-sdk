# DATABASE_KEY comes from BWS (project "common") at run time via
# with-database-key.sh; it is never in this file or the job env.
job "hyperliquid-sub4-rate-limit" {
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
        ACCOUNT = "sub4"
        ADDRESS = "0xfeb674f15e91c20e72d2da18f01d28b35b70cb08"
      }
    }
  }
}
