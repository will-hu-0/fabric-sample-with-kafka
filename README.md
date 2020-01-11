[![Build Status](https://travis-ci.org/keenkit/fabric-sample-with-kafka.svg?branch=master)](https://travis-ci.org/keenkit/fabric-sample-with-kafka)
# fabric-sample-with-kafka

## Description
The folder `first-nework` is copied from https://github.com/hyperledger/fabric-samples/tree/release-1.4 , different from verison 1.2 or before, the official `release-1.4` already contains `one zookeeper and one kafka` configuration inside.

Thereby this repository does a little change to support `3 zookeepers and 4 kakfas`.

Before drilling into this demo, please make sure you are very well understanding the offical Hyperledger Fabric
["Build Your First Network"](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html) tutorial.

Basically, we will have 
>1 orderer, 4 peers, 1 CLI, 4 Kafkas, 3 Zookeepers in our fabric network.

## Fabric Version
1.4.4

## Bianary files version
1.4.4

## How to run it?

#### 1. Get binaries & docker images
Download the necessary binaries and docker images (You may skip it if you have done it before). 

Go to root folder,
```shell
curl -sSL http://bit.ly/2ysbOFE | bash -s
```
After everything done you will have folder structure like:

```
fabric-sample-with-kafka$ tree
.
├── bin
│   ├── configtxgen
│   ├── configtxlator
│   ├── cryptogen
│   ├── discover
│   ├── fabric-ca-client
│   ├── idemixgen
│   ├── orderer
│   └── peer
├── chaincode
│   └── chaincode_example02
├── first-network
│   ├── base
...
```

#### 3. Run E2E test.

```shell
cd first-network

# Start up network
./byfn.sh up -o kafka
```

You will see log like this if no exception:

```shell
Starting for channel 'mychannel' with CLI timeout of '10' seconds and CLI delay of '3' seconds
Continue? [Y/n] 
proceeding ...
LOCAL_VERSION=1.4.4
DOCKER_IMAGE_VERSION=1.4.4
/home/will/Documents/blockchain/fabric-sample-with-kafka/first-network/../bin/cryptogen

##########################################################
##### Generate certificates using cryptogen tool #########
##########################################################
+ cryptogen generate --config=./crypto-config.yaml
org1.example.com
org2.example.com
+ res=0
+ set +x
.........
.........

90
===================== Query successful on peer1.org2 on channel 'mychannel' ===================== 

========= All GOOD, BYFN execution completed =========== 


 _____   _   _   ____   
| ____| | \ | | |  _ \  
|  _|   |  \| | | | | | 
| |___  | |\  | | |_| | 
|_____| |_| \_| |____/  
```

#### 4. Bring down the network

```shell
./byfn.sh down -o kafka
```
## What's behind the code change?

#### 1. Change first-network/configtx.yaml

Make sure change the SampleDevModeKafka content...

```yaml
    SampleDevModeKafka:
        <<: *ChannelDefaults
        Capabilities:
            <<: *ChannelCapabilities
        Orderer:
            <<: *OrdererDefaults
            OrdererType: kafka
            Kafka:
                Brokers:
                - kafka0.example.com:9092
                - kafka1.example.com:9092
                - kafka2.example.com:9092
                - kafka3.example.com:9092   
```

#### 2. Add first-network/base/kafka-base.yaml

It is just a kafka/zookeeper base yaml files to be referenced.

#### 3. Change first-network/docker-compose-kafka.yaml

Modify and add more zookeepers & kafka nodes

## Issues
1. Make sure you have the **RIGHT** version binaries as well as fabric image versions.
In this case it is **1.4.4**

2. Make sure the **1.4.4** fabric images are marked as Latest.

```
hyperledger/fabric-ccenv          1.4.4               ca4780293e4c        8 weeks ago         1.37GB
hyperledger/fabric-ccenv          latest              ca4780293e4c        8 weeks ago         1.37GB
```
3. For previous version, please check

- 1.2.0 https://github.com/keenkit/fabric-sample-with-kafka/tree/release-1.2.0
- 1.0.6 https://github.com/keenkit/fabric-sample-with-kafka/tree/release-1.0.6
