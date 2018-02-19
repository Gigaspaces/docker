##  XAP In-Memory Data Grid

![XAP logo](https://docs.gigaspaces.com/images/logo-xap-color-small.png)

## What is XAP?

XAP is a cloud-native, high-throughput and low-latency application fabric that empowers real-time, event-driven microservices and distributed applications for internet-scale innovation. XAP scales with your business needs, from simple data processing, to complex transactional workloads, all the way to leveraging hybrid storage and data center tiers.


XAP provides the following advantages:

- Enables your entire app to run entirely on a single platform with all the tiers collapsed into one container.
- Gives you fast data access by storing ALL your data in-memory. It also ensures high availability with in-memory backup within each container.
- Scales your app automatically and on demand.

To learn more about GigaSpaces products, visit the [website](https://www.gigaspaces.com).

***

**Early Access**

This XAP Docker image is based on our XAP 12.3 early access build, which is still under construction. Your feedback is appreciated.

***

## Table of Contents

- [Getting Started](#getting-started)
- [How to Use this Image](#how-to-use-this-image)
- [Running Your First Container](#running-your-first-container)
- [Running a Test Cluster on Your Host](#running-a-test-cluster-on-your-host)
- [Running a Production Cluster on Multiple Hosts](#running-a-production-cluster-on-multiple-hosts)
- [Beyond the Basics](#beyond-the-basics)
    - [Using a Different Java Version](#using-a-different-java-version)
    - [Accessing the XAP Logs](#accessing-the-xap-logs)
    - [Multiple Configuration Settings](#multiple-configuration-settings)
    - [Adding or Overriding Libraries](#adding-or-overriding-libraries)

# Getting Started

To test the XAP Docker image, run the following in your command line to display a help screen with all the available commands: 

```
docker run gigaspaces/xap --help
```


 For example, the `version` command prints version information:

```
docker run gigaspaces/xap version
```

# How to Use this Image

The XAP Docker image utilizes GigaSpaces' XAP command line interface (CLI). [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/command-line-interface.html "XAP CLI documentation")

# Running Your First Container

The simplest and fastest way to start working with XAP is to get a single instance up and running on your local machine.  After the instance is initiated, you can start to explore the various features and capabilities.

To run a single host on your machine:

```
docker run --name test -e XAP_LICENSE=tryme -p 8090:8090 -p 8099:8099 gigaspaces/xap
```

This command includes the  XAP `tryme` license, which enables you to use the full XAP product for 24 hours (you can  get a longer evaluation license from the [GigaSpaces](http://gigaspaces.com) website).

When running the XAP Docker image without arguments, a host is automatically started with the following components:

* XAP Manager (mapped to port `8090`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager.html)
* Web Management Console (mapped to port `8099`) [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/web-management-console.html)

*Note: These ports are mapped to your host, so you can access them.*

# Running a Test Cluster on Your Host

If you want to test high availability or other distributed features on a single host, you can start multiple instances of XAP. All you need to do is assign identities so they can communicate with each other, and specify which containers will run the XAP Manager service. For example:

```
XAP_MANAGER_SERVERS=host1,host2,host3
XAP_LICENSE=tryme
docker run --name test1 -h=host1 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS -p 8090:8090 -p 8099:8099 gigaspaces/xap
docker run --name test2 -h=host2 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS -p 8091:8090 -p 8100:8099 gigaspaces/xap
docker run --name test3 -h=host3 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap
docker run --name test4 -h=host4 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap
docker run --name test5 -h=host5 -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap
```

Due to starting multiple management containers on the same host, the ports of the 2nd and 3rd containers must be mapped to different host ports, in order to avoid conflicts with the 1st container. The rest of the containers don't expose any ports; they are connected to the management nodes via Docker's default bridge network, and are managed through the Web Management Console or REST Manager API. [Learn more](https://docs.gigaspaces.com/xap/12.3/admin/xap-manager-rest.html)

# Running a Production Cluster on Multiple Hosts

*Note: this section describes a solution approach, which is still under construction and not yet available.*

In a production environment, you will likely want to run a container per host, to achieve true high availability and use your resources efficiently. To avoid port mapping and improve performance, we'll use the `--net=host` command.

For this scenario, let's assume there are 5 hosts named `test1`..`test5`, similar to the previous example.  On each host, run the following:
```
XAP_MANAGER_SERVERS=host1,host2,host3
XAP_LICENSE=tryme
docker run --name test --net=host -d -e XAP_LICENSE -e XAP_MANAGER_SERVERS gigaspaces/xap
```
## Beyond the Basics

# Using a Different Java Version

This XAP Docker image is based on the official [openjdk](https://hub.docker.com/_/openjdk/) image, and uses Java version 8. To use a different Java version, you have to build a new image using the `JAVA_TAG` build argument. For example:
```
docker build --build-arg JAVA_TAG=9 -t gigaspaces/xap:openjdk-9 .
```
If you're not sure which versions are available, refer to the [supported tags](https://hub.docker.com/r/library/openjdk/tags/) page.

You can also build from a different base image, as long as it contains Java. For example, [sgrio/java-oracle](https://hub.docker.com/r/sgrio/java-oracle/) is an unofficial image of Oracle Java.

*Note: To use this image, you must accept the [Oracle Binary Code License Agreement](http://www.oracle.com/technetwork/java/javase/terms/license/index.html) for Java SE*:
```
docker build --build-arg JAVA_IMAGE=sgrio/java-oracle --build-arg JAVA_TAG=latest -t gigaspaces/xap:java-oracle .
```

#  Accessing the XAP Logs

All logs are stored in `opt/gigaspaces/logs` within the container. To access to the logs, you can do one of the following:

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

# Multiple Configuration Settings

*Note: This feature is still under construction.*

 (use env file/ -v with setenv-overrides / extend docker image)

# Adding or Overriding Libraries

*Note: This feature is still under construction.*

( -v / extend docker image)
