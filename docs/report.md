# NSS-Cloud Report

## 1 System Goals (1 point)

### 1.1 Qualitative Goals
- mention of some use cases and desired goals
- privacy

### 1.2 Quantitative Goals
- performance
- reliability

### 1.3 Use Cases
- personal clound for storing and sharing family pictures etc.
- self-made home security camera system (old android phone -> over-tls-stream -> openCV for object detection -> nextcloud as userinterface)

## 2 System architecture (2 points)
### 2.1 Nextcloud server architecture

![Figure 1](fig-1-nextcloud-setup.png)

Figure 1 - Scalable Nexcloud setup example. NFS (Network file system) as storage layer, an LDAP (Lightweight Directory Access Protocol) user directory, caching, databases and load balancer.  [\[NC-WP\]](#nc-wp)

In principle Nextcloud server is a web application based on PHP and can be run with any webserver, such as Apache or NGINX. The core of Nextcloud provides storage of file sharing information, user details, application data, configuration and file information in database (MySQL, MariaDB and PostegreSGL are supported). Additional features are available with added services and setup. Plenty of NFS soulutions work natively with Nextcloud. [\[NC-WP\]](#nc-wp)

To access data Nextcloud provides intuitive interface through web browser, Android, iOS or desktop applications.

### 2.2 NSS-cloud adoption

- nextcloud core on vm
- MariaDB in container - communicating with the core over TLS 1.3 (TLS_AES_256_GCM_SHA384), limited to 256mb wutg 256mb swap from vHDD and atmost 0.5 vCPU usage.
- Clients connect through HTTPS connection - Let's Encrypt certificate

Specs
- vm running on csc - Ubuntu 20.04, 1vCPU, 1GB RAM.

## 3 Components / Module description including the interfaces exposed between the modules (2 points)
- mariadb (docker)
- nextcloud server (tls to mariadb container. https serve for client)
- client - over https through web 
- certification bot - let's encrypt 
- apache

## 4 Communication channel between the modules. For instance, do the modules use secure communication to communicate with each other, if yes, how? (2 points)

- server and client over HTTPS
- nextcloud and database over TLS? perhaps

## 5 Pros and cons of the open-source components/modules used for developing the system, and the modules/components you have built (3 points)

Nextcloud
pros:
- free
- beginner friendly base and basic setup
- decent documentation
- auditability

cons:
- 

nss-ca
certificate chain generation and signing
- good for personal usage
- cannot be trustworthy otherwise

## 6 Which of the fallacies of the distributed system does your system violate, and how (1 points).

### 6.1 Network is reliable
### 6.2 Latency is zero
### 6.3 Infinite bandwidth
### 6.4 Network is secure
### 6.5 Topology doesn’t change
### 6.6 There is one administrator
### 6.7 Transport cost is zero
### 6.8 Network is homogeneous

## 7 What needs to be added to your system be used to be integrated/extended by another system (2 points).
- manual installation
- cetrificate
- add trusted to have multiple instances running together (federation)

## 8 Evaluation. Methodology used for evaluating the system performance, and the key results (2 points)

- latency, throughput / bandwidth?

## 9 Conclusion / Learning

## Resources
<a id="nc-wp">\[NC-WP\]</a> - Nextcloud Solution Architecture whitepaper. [Link](https://nextcloud.com/media/wp135098u/Architecture-Whitepaper-WebVersion-072018.pdf). Accessed 09.10.2021.