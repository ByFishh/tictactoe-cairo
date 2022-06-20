JSON			=	./build/main.json
NETWORK			=	alpha-goerli

all:	build

build:
	protostar build

deploy:
	protostar deploy $(JSON) --network $(NETWORK)

test:
	protostar test ./tests

clean:
	rm -rf ./build

re:	clean all

.Phony: all deploy test clean re