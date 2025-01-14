deploy_coin:
	forge script script/FloCoin.s.sol:FloCoinScript --rpc-url ${RPC_BSC_MAIN} --private-key ${PRIVATE_KEY} --verify -vvvv
deploy_gov:
	forge script script/Gov.s.sol:GovScript --rpc-url ${RPC_BSC_MAIN} --private-key ${PRIVATE_KEY} --verify -vvvv

deploy_gov_testnet:
	forge script script/GovTestnet.s.sol:GovTestnetScript --rpc-url ${RPC_BSC_TEST} --private-key ${WALLET_EVM_TEST1_KEY} --verify --broadcast