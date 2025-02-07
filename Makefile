deploy_coin:
	forge script script/FloCoin.s.sol:FloCoinScript --rpc-url ${RPC_BASE_MAIN} --private-key ${PRIVATE_KEY} --verify -vvvv
deploy_gov:
	forge script script/Gov.s.sol:GovScript --rpc-url ${RPC_BASE_MAIN} --private-key ${PRIVATE_KEY} --verify -vvvv

deploy_coin_testnet:
	forge script script/FloCoin.s.sol:FloCoinScript --rpc-url ${RPC_BASE_SEPOLIA} --private-key ${WALLET_EVM_TEST1_KEY} --broadcast
deploy_gov_testnet:
	forge script script/GovTestnet.s.sol:GovTestnetScript --rpc-url ${RPC_BASE_SEPOLIA} --private-key ${WALLET_EVM_TEST1_KEY} --broadcast