# TODO:
# coin:
# 	forge script script/FloCoin.s.sol:FloCoinScript --rpc-url ${RPC_BASE_MAIN} --private-key ${PRIVATE_KEY}
# gov:
# 	forge script script/Gov.s.sol:GovScript --rpc-url ${RPC_BASE_MAIN} --private-key ${PRIVATE_KEY} 

# testnet
testnet_coin:
	forge script script/FloCoin.s.sol:FloCoinScript --rpc-url 'base-sepolia' --account testnet --broadcast
testnet_gov:
	forge script script/GovTestnet.s.sol:GovTestnetScript --rpc-url 'base-sepolia' --account testnet --broadcast