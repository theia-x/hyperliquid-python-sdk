import json

import example_utils
import time
from hyperliquid.utils import constants
from datetime import datetime

def main():
    TRADING_ADDRESS = "" # TODO: add your trading address
    GPT_ADDRESS = "0x67293d914eafb26878534571add81f6bd2d9fe06"

    # fill secret key and account address in config.json
    address, info, exchange = example_utils.setup(base_url=constants.MAINNET_API_URL, skip_ws=True, vault_address=TRADING_ADDRESS)

    # Get the user state and print out position information
    user_state = info.user_state(GPT_ADDRESS)
    gpt_positions = {}
    for position in user_state["assetPositions"]:
        gpt_positions[position["position"]["coin"]] = float(position["position"]["szi"])

    # Get my current positions 
    user_state = info.user_state(TRADING_ADDRESS)
    my_positions = {}
    for position in user_state["assetPositions"]:
        my_positions[position["position"]["coin"]] = float(position["position"]["szi"]) 

    ideal_positions = {}
    # get the difference from mine vs agent positions 
    for coin, sz in gpt_positions.items():
        ideal_positions[coin] = sz - (my_positions.get(coin, 0.0) * -1) # invert my positions

    # if it exists in my positions, but not in gpt positions, close it
    for coin, sz in my_positions.items():
        if coin not in gpt_positions:
            print("close position", coin, sz)
            ideal_positions[coin] = sz

    # Place an inverse order
    for coin, sz in ideal_positions.items():
        if sz < 0:
            print("Buying", coin, -sz)
            print(exchange.market_open(coin, True, -sz))
        elif sz > 0:
            print("Selling", coin, sz)
            print(exchange.market_open(coin, False, sz))

    


if __name__ == "__main__":
    main()
