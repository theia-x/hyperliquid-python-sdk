import example_utils
from hyperliquid.utils import constants
import requests
import dotenv
import os
from datetime import datetime, timezone

def main():
    dotenv.load_dotenv()
    ADDRESS = os.getenv("ADDRESS")
    print(ADDRESS)
    address, info, exchange = example_utils.setup(constants.MAINNET_API_URL, skip_ws=True)
    rate_limit_info = info.user_rate_limit(ADDRESS)

    
    BASE_URL = "https://bagendhq.xyz"
    ENDPOINT = "/backend/rate-limit-report"
    DB_URL = f"{BASE_URL}{ENDPOINT}"
    DB_KEY = os.getenv("DATABASE_KEY")
    if not DB_KEY:
        raise SystemExit("DATABASE_KEY is not set (run via with-database-key.sh)")

    ACCOUNT = os.getenv("ACCOUNT")
    print(ACCOUNT)

    used_rates = int(rate_limit_info["nRequestsUsed"])
    remaining_rates = int(rate_limit_info["nRequestsCap"]) - used_rates

    payload = {
        "rate_limits": [
            {
                "exchange": "hyperliquid",
                "account": ACCOUNT,
                "ts_us": datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S.%f%z'),
                "remaining": remaining_rates,
            }
        ]
    }

    # db_backend auth: Bearer header, never a ?key= query param.
    headers = {"Authorization": f"Bearer {DB_KEY}"}

    response = requests.post(DB_URL, headers=headers, json=payload)
    print(response.json())


if __name__ == "__main__":
    main()
