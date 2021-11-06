serve:
	cd fakeapi
	make -C fakeapi serve &
	elm-app start
