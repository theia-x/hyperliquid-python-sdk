# DATABASE_KEY comes from BWS (project "common") at run time via
# with-database-key.sh; it is never in this file or the job env.
job "hyperliquid-sub3-rate-limit" {
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
        ACCOUNT = "sub3"
        ADDRESS = "0x7225a33aff56591393b77d411bce2b4664d4c723"
      }
    }
  }
}
