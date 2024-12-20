deploy:
	foundry script script/FloCoin.s.sol:FloCoinScript --rpc-url ${RPC_BSC_MAIN} --private-key ${PRIVATE_KEY} --verify --verify-api-key ${VERIFY_KEY} -vvvv
