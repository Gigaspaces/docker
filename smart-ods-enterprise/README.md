## InsightEdge Smart ODS

![InsightEdge logo](https://docs.gigaspaces.com/images/logo-insightedge-color-small.png)

## What is Smart ODS Enterprise?

Smart ODS is a distributed in-memory Digital Integration Hub (DIH), with unparalleled low-latency, high-performance and scale that aggregates and offloads from your multiple back-end systems of record and data stores on-premise and in the cloud. With a unified API layer, you can decouple the digital applications from your disparate systems of record to increase agility and ensure always-on services.

Benefits & Features: 
* Extreme In-Memory Performance - unparalled speed, high-throughput transaction (ACID), and analytical processing to accelerate applications, BI and analytics; fueled by distributed in-memory speed, the colocation of business logic and data, secondary indexing and server-side aggregations.
* AIOps for Autonomous Elasticity and Scale - automatic triggers to elastically scale either up or out for transactional and analytical workloads, based on the CPU and RAM utilization. The scaling process is done in a rolling manner without downtime while the cache remains fully operational.
* Business Policy-Driven Storage - intelligently manage your data in multiple storage tiers – hot on RAM, warm on SSD and cold on your data store, with an automated data lifecycle driven by business-policy logic and actual usage patterns. You’re no longer limited to LRU tiering logic.
* Colocated Microservices - deploy microservices colocated in memory to achieve extreme performance and agility. High ingestion of data streams and events with a real-time processing engine lets you execute on the server complex transformations and data enrichment in a distributed manner.
* No Code, One-Click Integration - with just one click, the platform scans the database and its metadata, maps its data modeling to the GigaSpaces store and defines its indexing and partitioning schema to eliminate weeks of manual work and human errors. You can also use a built-in CDC that connects directly to your systems of records.
* Always-On Services - enterprise-grade and highly available with three levels of data persistence, including in-memory, disk/database persistency, and cross-region replication. Self-healing functionality as well as upgrades and scaling without downtime.

To learn more about GigaSpaces products, visit the [website](https://www.gigaspaces.com).

***

## Table of Contents

- [Getting Started](#getting-started)
- [How to Use this Image](#how-to-use-this-image)
- [Running Your First Container](#running-your-first-container)
- [Connecting to the Client](#connecting-to-the-client)
- [Running the Client with the Docker Bridge Network](#running-the-client-with-the-docker-bridge-network)
- [Running the Client in Another Docker Container](#running-the-client-in-another-docker-container)
- [Using the Host Network](#using-the-host-network)
- [Configuring the Public Host](#configuring-the-public-host)
- [Running a Production Cluster on Multiple Hosts](#running-a-production-cluster-on-multiple-hosts)
- [Beyond the Basics](#beyond-the-basics)
    - [Configuring the GigaSpaces Manager Server IP Address](#configuring-the-gigaspaces-manager-server-ip-address)
    - [Ports](#ports)
    - [Running Other CLI Commands](#running-other-cli-commands)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the Logs](#accessing-the-logs)

# Getting Started

To test the Smart ODS Enterprise Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/smart-ods-enterprise --help
```


 For example, the `version` command prints version information:

```
docker run gigaspaces/smart-ods-enterprise version
```

# How to Use this Image

The Smart ODS Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). To learn more about the command line interface, see the [CLI documentation](https://docs.gigaspaces.com/latest/admin/tools-cli.html "CLI documentation"), or use the `--help` option.

The Smart ODS Enterprise image requires a license key to run, which can be provided using the `GS_LICENSE` environment variable. You can use the `tryme` license, which enables you to use the full Smart ODS product for 24 hours (and then terminates the image), or you can  get a longer [evaluation license](http://gigaspaces.com/eval-license).


# Running Your First Container

The simplest and fastest way to start working with Smart ODS Enterprise is to get a single instance up and running on your local machine.  After the instance is initiated, you can start exploring the available features and capabilities.

To run a single host on your machine:

```
docker run --name test -it -e GS_LICENSE=tryme -p 8090:8090 -p 8099:8099 gigaspaces/smart-ods-enterprise
```

When running the Smart ODS Enterprise Docker image without arguments, a host is automatically started with the following components:

* Platform Manager (mapped to port `8090`) [Learn more](https://docs.gigaspaces.com/latest/admin/xap-manager.html)
* Web Management Console (mapped to port `8099`) [Learn more](https://docs.gigaspaces.com/latest/admin/tools-web-ui.html)

*Note: These ports are mapped to your host, so you can access them.*


# Connecting to the Client

Docker runs containers in a bridge network by default. You can use any of the options described below to enable a client to connect to the Space.

### Running the Client with the Docker Bridge Network

By default, the client uses the host network interface. You can configure the client to use the Docker bridge network interface (the IP address is usually 172.17.0.x). Use the `GS_NIC_ADDRESS` environment variable to enable the client to contact and interact with the Space.

**NOTE: This only works for clients that reside on the same host as the Space. The Docker bridge network is inaccessible to other hosts.**

### Running the Client in Another Docker Container

Docker containers that reside on the same host use the same bridge network. If the client is in a Processing Unit, you can run it via another Docker container with the `pu run` command.

**NOTE: This only works for clients that reside on the same host as the Space. Docker containers on other hosts will use a different bridge network.**

### Using the Host Network

Docker can run containers on the host network using the `--net=host` option with the `docker run` command. In this case, the client can connect and interact with the Space without additional configuration.

**NOTE: Docker only supports the `--net=host` option on Linux hosts.**

### Configuring the Public Host

By default, the GigaSpaces communication protocol (LRMI) uses the same network interface for both binding and publishing. You can modify this, using the `GS_PUBLIC_HOST` enviromnent variable to instruct Smart ODS Enterprise to publish itself using a different network address, for example the host's network address. In this case, you'll have to expose the ports listed in the [Ports](#ports) section from the Docker container to the host. For example:

```
docker run --name test -it -e GS_LICENSE=tryme -e GS_PUBLIC_HOST=<your-host-ip-or-name> -p 4174:4174 -p 8200-8300:8200-8300 gigaspaces/smart-ods-enterprise
```

# Running a Production Cluster on Multiple Hosts

When running Smart ODS Enterprise in Docker containers on multiple hosts, you need to either configure `GS_PUBLIC_HOST` or use the `--net=host` option as described above, so that containers on different hosts can interact with each other.

The `GS_PUBLIC_HOST` environment variable complies with common practices of Docker usage, and maintains image isolation. However, as per the Docker documentation, to get optimal performance it is recommended to use the `--net=host` option, which uses the host network and removes the extra network hop. The Smart ODS Docker image supports both options, so choose the one that best suits your needs.

## Beyond the Basics

# Configuring the GigaSpaces Manager Server IP Address

 When running Smart ODS Enterprise on multiple hosts, you can configure the GigaSpaces Manager Server IP address in your network. 
`GS_MANAGER_SERVERS=host1,host2,host3` by default is the local manager.

# Ports

The Smart ODS Enterprise Docker image uses the ports described in the table below. You can change each port using the respective environment variable, or map it to a different port using the `-p` option in `docker run`. For example, `-p 5174:4174` maps the lookup discovery port to a different port, but maintains the same port within the container.

| Environment Variable                      | Default Value | Description |
| ------------------------------------------|---------------|-------------|
| GS_MULTICAST_LOOKUP_PORT                  | 4174          | Lookup discovery port. [(learn more)](https://docs.gigaspaces.com/latest/admin/network-lookup-service-configuration.html) |
| GS_LRMI_PORT                              | 8200-8300     | Network protocol port range. [(learn more)](https://docs.gigaspaces.com/latest/admin/tuning-communication-protocol.html) |
| GS_MANAGER_REST_PORT                      | 8090          | REST Manager API port [(learn more)](https://docs.gigaspaces.com/latest/admin/xap-manager-rest.html) |
| GS_WEBUI_PORT                             | 8099          | Web Managment Console port [(learn more)](https://docs.gigaspaces.com/latest/admin/tools-web-ui.html) |
| GS_WEBSTER_HTTP_PORT                      | 8199          | Internal web service used as part of the application deployment process.
| GS_RMI_REGISTRY_PORT                      | 10098-10108   | Used to communicate with the client application.
| GS_ZOOKEEPER_CLIENT_PORT                  | 2181          | Used for the Zookeeper client.
| GS_MANAGER_ZOOKEEPER_DISCOVERY_PORT       | 2888          | Used for the Zookeeper discovery ports.
| GS_MANAGER_ZOOKEEPER_LEADER_ELECTION_PORT | 3888          | Used for the Zookeeper leader election port.


# Running Other CLI Commands

The Smart ODS Enterprise Docker image utilizes GigaSpaces' command line interface (CLI). Any arguments following the image name are passed to the command line.

If no arguments are specified after the image, the default `host run-agent --auto` command will be run.

To learn more about the command line interface, refer to the [CLI documentation](https://docs.gigaspaces.com/latest/admin/tools-cli.html "CLI documentation"), or use the `--help` option.

# Using a Different Java Version

This Smart ODS Enterprise Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/smart-ods-enterprise:openjdk-9 .
```
If you're not sure which versions are available, refer to the [supported tags](https://hub.docker.com/r/library/openjdk/tags/) page.

You can also build from a different base image, or even create your own, using the `JAVA_IMAGE` build argument (e.g. `--build-arg JAVA_IMAGE=...`)

#  Accessing the Logs

All logs are stored in `opt/gigaspaces/logs` within the container. To access the logs, you can do one of the following:

- Use the `-v` option in your `docker run` command to map this to a folder on your host.
- Use the `docker cp` command to copy the files from a Docker instance to a location on your host.

To mount the directory to get the logs, use the following command:
```
 -v c:/gigaspaces/test/logs:/opt/gigaspaces/logs
```
To copy logs from a running instance, use the following command:
```
docker cp containerId:/opt/gigaspaces/logs .
```
