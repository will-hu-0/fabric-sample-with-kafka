[![Build Status](https://travis-ci.org/keenkit/fabric-sample-with-kafka.svg?branch=master)](https://travis-ci.org/keenkit/fabric-sample-with-kafka)
# fabric-sample-with-kafka

## Description
This is a folked repository from https://github.com/hyperledger/fabric-samples/tree/release/first-network with **Kafak** order type integrated.

Before drilling into this demo, please make sure you are very well understanding the offical Hyperledger Fabric
["Build Your First Network"](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html) tutorial.

## Version
1.0.4

## How to run it?

#### 1. Get binaries 
Download the necessary binaries (You may skip it if you have done it before). 

Go to root folder,
```shell
./get-byfn.sh
```

#### 2. Pull docker images

Pull the farbric docker images. (You may skip it if you have done it before).

 Go to root folder,
```
./get-docker-images.sh
```

#### 3. Run E2E test.

```shell
cd first-network

# Start up network
./byfn.sh up
```

You will see log like:

```shell
Starting with channel 'mychannel' and CLI timeout of '10' seconds and CLI delay of '3' seconds
Continue? [Y/n] Y
proceeding ...
/home/will/Documents/fabric-sample-with-kafka/first-network/../bin/cryptogen

##########################################################
##### Generate certificates using cryptogen tool #########
##########################################################
org1.example.com
org2.example.com
............
............

Creating network "net_byfn" with the default driver
Creating peer0.org1.example.com ... 
Creating peer1.org1.example.com ... 
Creating peer0.org2.example.com ... 
Creating zookeeper2.example.com ... 
Creating zookeeper1.example.com ... 
Creating zookeeper0.example.com ... 
Creating peer1.org2.example.com ... 
Creating peer1.org1.example.com
Creating peer0.org1.example.com
Creating zookeeper2.example.com
Creating peer0.org2.example.com
Creating zookeeper1.example.com
Creating peer1.org2.example.com
Creating peer1.org2.example.com ... doneCreating zookeeper0.example.com ... done
Creating kafka0.example.com ... 
Creating kafka2.example.com ... 
Creating kafka3.example.com ... 
Creating kafka1.example.com ... 
Creating kafka3.example.com
Creating kafka0.example.com
Creating kafka2.example.com
Creating kafka0.example.com ... done
Creating orderer.example.com ... 
Creating orderer.example.com ... done
Creating cli ... 
Creating cli ... done

 ____    _____      _      ____    _____ 
/ ___|  |_   _|    / \    |  _ \  |_   _|
\___ \    | |     / _ \   | |_) |   | |  
 ___) |   | |    / ___ \  |  _ <    | |  
|____/    |_|   /_/   \_\ |_| \_\   |_|  

Build your first network (BYFN) end-to-end test

Channel name : mychannel
Creating channel...
```

#### 4. Bring down the network

```shell
./byfn.sh down
```
## What's behind the code change?

#### 1. first-network/configtx.yaml

```yaml
# Available types are "solo" and "kafka"
OrdererType: kafka

....
Kafka:
    # Brokers: A list of Kafka brokers to which the orderer connects
    # NOTE: Use IP:port notation
    Brokers:
        - kafka0.example.com:9092
        - kafka1.example.com:9092
        - kafka2.example.com:9092
        - kafka3.example.com:9092      

```

#### 2. first-network/docker-compose-kafka.yaml

Be noticed that zookeepers and kafkas are added, be sure they are with *byfn* network:

```shell
networks:
  - byfn
```
Orderer should be started up after kafkas

```yaml
  orderer.example.com:
    extends:
      file:   base/docker-compose-base.yaml
      service: orderer.example.com
    container_name: orderer.example.com
    depends_on:
      - kafka0.example.com
      - kafka1.example.com
      - kafka2.example.com
      - kafka3.example.com  
    networks:
      - byfn    
```      

#### 3. first-network/base/docker-compose-base.yaml

Add zookeepers & kafka nodes

#### 4. base/kafka-base.yaml & base/order-base.yaml

Check the source code from them.

#### 5. byfn.sh

Update COMPOSE_FILE:

```shell
# use this as the default docker-compose yaml definition
COMPOSE_FILE=docker-compose-kafka.yaml
```

Sleep some time before bring up docker containers:

```shell
# Generate the needed certificates, the genesis block and start the network.
function networkUp () {
  ....
  ....
  # now run the end to end script
  sleep 5 # <== Check this line
  docker exec cli scripts/script.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT 

  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Test failed"
    exit 1
  fi
}
```