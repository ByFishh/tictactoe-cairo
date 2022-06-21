JSON			=	./build/main.json
NETWORK			=	alpha-goerli

all:

install:
	pip install -r requirements.txt

build: clean
	protostar build

deploy:
	protostar deploy $(JSON) --network $(NETWORK)

test:
	protostar test ./tests

clean:
	rm -rf ./build

re:	clean build

.Phony: all install builddeploy test clean re