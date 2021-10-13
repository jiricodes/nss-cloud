# NSS-Cloud Report
## 0 TOC

- [1 System Goals](#1-system-goals)
	- [1.1 Qualitative Goals](#11-qualitative-goals)
	- [1.2 Quantitative Goals](#12-quantitative-goals)
	- [1.3 Use Cases](#13-use-cases)
- [2 System architecture](#2-system-architecture)
	- [2.1 Nextcloud server architecture](#21-nextcloud-server-architecture)
	- [2.2 NSS-cloud adoption](#22-nss-cloud-adoption)
- [3 Components](#3-components)
	- [3.1 Nextcloud](#31-nextcloud)
	- [3.2 PostegreSQL](#32-postegresql)
	- [3.3 LDAP](#33-ldap)
	- [3.4 Certification BOT](#34-certification-bot)
	- [3.5 Clients](#35-clients)
- [4 Communication](#4-communication)
- [5 Open source modules evaluation](#5-open-source-modules-evaluation)
	- [5.1 Nextcloud](#51-nextcloud)
	- [5.2 Let's Encrypt](#52-lets-encrypt)
	- [5.3 Optional nss-ca](#53-optional-nss-ca)
- [6 Fallacies](#6-fallacies)
	- [6.1 Network is reliable](#61-network-is-reliable)
	- [6.2 Latency is zero](#62-latency-is-zero)
	- [6.3 Infinite bandwidth](#63-infinite-bandwidth)
	- [6.4 Network is secure](#64-network-is-secure)
	- [6.5 Topology doesn’t change](#65-topology-doesnt-change)
	- [6.6 There is one administrator](#66-there-is-one-administrator)
	- [6.7 Transport cost is zero](#67-transport-cost-is-zero)
	- [6.8 Network is homogeneous](#68-network-is-homogeneous)
- [7 Further development](#7-further-development)
	- [7.1 Deployment](#71-deployment)
	- [7.2 Federation](#72-federation)
	- [7.3 Additional Services and Features](#73-additional-services-and-features)
	- [7.X Others](#7x-others)
- [8 Evaluation](#8-evaluation)
- [9 Conclusion / Learning](#9-conclusion-/-learning)

## TBC Introduction?
This report discusses bla bla bla
　
## 1 System Goals
This section introduces primary goals of the system and serves as a basis for all decisions regarding the practical implementation of the system. The goals can generally be divided into two categories, qualitative goals and quantitative goals, though some may also fall into both. Additionally, we describe some potential use cases as keeping them in mind will allow us to design our system from the ground up to be used effectively in practice.


### 1.1 Qualitative Goals
**Privacy** is one of the core drivers and goals of this project. As more and more data, services, and even infrastructure (e.g. DNS resolution) are being centralized by the top players in the cloud industry, there is an increasing need for alternate options for those who need a guarantee of privacy and data confidentiality (resources TBC - confidential dns, confidential computing, GDPR). This need could be to some extent satisfied with personal cloud deployment on local network or self-hosted cloud.

**Security** goes hand-in-hand with privacy, as there cannot be any true privacy if the service is insecure, even if it is being self-hosted. This is also especially important considering that it is a "personal" cloud, which should be secure enough to safely store any sensitive personal data that users store on it.

### 1.2 Quantitative Goals
Depending on use case, some quantitative metrics may be required or at least welcomed by the consumer.

**Reliability** of the service is crucial, and users' data should remain accessible and loss-proof at all times. The entire point of a personal cloud is storage, and if the service is unreliable and data is inaccessibly or lost, then it is a complete failure of the system.

**Performance** is use case and demployment-specific, but the software and protocols should introduce minimal performance overhead and be capable of running on low-end consumer machines, e.g. NUCs. Data storage is now a relatively simple task, especially at the basic consumer level, so poor performance should be a cause for concern.


### 1.3 Use Cases
To what end an user would like to utilise the system may widely vary. However, we will introduce few use cases for the NSS-cloud system.

The personal cloud can be simply used as a storage and sharing platform as any other widely used platform (Google, iCloud etc.). However, due to its locality and low amount of users the consumer benefits by relatively high privacy guarantees and potentially much higher perfomance (HW dependant). Of course for the cost of greater availability outside of the local network. The tradeoff can be somewhat balanced by self hosting the system, which on the other hand increases the attack surface.

Another use could be seen by combination of the personal cloud with a home assistant (e.g. open source [Home Assistant](https://www.home-assistant.io/)), which would have similar benefits as above mentioned use case. Additionally this would lower chance of external misuse and improved responsiveness and debugging of the home assistent settings. 

One rather complex, DIY-style, application could be seen with development of custom security cameras. That could potentially be even connected to the previous use case. One could recycle old smartphone to serve as a security camera feed (e.g. over TLS) to the home server, where for example with framework like [OpenCV](https://opencv.org/) the images are processed for object detection or individuals identification. The personal cloud could play various roles in this model, from data processing, storing to interfacing such model using its API, and mitigating the thread of possibly sensitive data leakage.

## 2 System architecture
### 2.1 Nextcloud server architecture

![Figure 1](fig-1-nextcloud-setup.png)

*Figure 1 - Scalable Nexcloud setup example. NFS (Network file system) as storage layer, an LDAP (Lightweight Directory Access Protocol) user directory, caching, databases and load balancer.  [\[NC-WP\]](#nc-wp)*

In principle Nextcloud server is a web application based on PHP and can be run with any webserver, such as Apache or NGINX. The core of Nextcloud provides storage of file sharing information, user details, application data, configuration and file information in database (MySQL, MariaDB and PostegreSGL are supported). Additional features are available with added services and setup. Plenty of NFS soulutions work natively with Nextcloud. [\[NC-WP\]](#nc-wp)

To access data, but also to configure, monitor and manage, Nextcloud provides intuitive interface through web browser, Android, iOS or desktop applications. Alternatively resources can handled via WebDAV standard API. 

### 2.2 NSS-cloud adoption

<a id="figure-2">![Figure 2](nss-cloud-arch.png)</a>

*Figure 2 - NSS cloud architecture. Clients connect to Nextcloud over HTTPS. Default OS filesystem is used. PostegreSQL running in a container utilised over TLS.*

Since our primary goal is a personal use of the cloud infrastructure (see [1.3 Use Cases](#13-use-cases)) we do not expect high traffic environment and the whole system should comfortably fit on low spec consumer hardware (e.g. NUC). Therefore our practical application has been concluded as depicted in [Figure 2](#figure-2).

The Nextcloud server system runs within a single virtual machine (VM). The VM has allocated 1 vCPU and 1GB RAM and contains a minimal default instalation of Ubuntu 20.04 operating system. It is natively installed and configured (not in a container). The system utilises PostegreSQL database which is running in a container and communicates over TLS. The database has restricted resources access with 256MB for storage (additional 256MB swap space) and limited to upmost 0.5 vCPU usage. Linux native file system interface is used for object storage.

Clients can connect using either the Nextcloud app available on major OS or via web browser interface. The connection is secured over HTTPS and utilises trustworthy automated Let's Encrypt certificate.

For administration purposes the VM exposes a port for secure SSH connection.


	- The server system runs within a single VM (Ubuntu 20.04, 1 vCPU, 1GB RAM)
	- The Nextcloud has been natively installed and configured
	- It utilises PostegreSQL which is running in constrained environment of a 	container
		- 256MB storage with 256MB additional swap space from vHDD and allowed 	to use upmost 0.5 vCPU
		- the communication protocol between Nextcloud and database is TLS 1.3 	(TLS_AES_256_GCM_SHA384)
	- Clients connect through web browser using secure HTTPS connection with 	Let's Encrypt certificate


## 3 Components
	Components / Module description including the interfaces exposed between the modules

All in VM, and with Apache. Exposed ports for HTTPS and SSH connections.

### 3.1 Nextcloud
Direct installation. ([nextcloud docs](https://docs.nextcloud.com/server/latest/admin_manual/installation/source_installation.html))

TLS 1.3 to database

HTTPS to clients

### 3.2 PostegreSQL
Database in a docker container connected via TLS 1.3.
SSL must be used if the database is not on the same server as the Nextcloud instance, which is not currently the case with our project.

### 3.3 LDAP
TBC

### 3.4 Certification BOT
Let's Encrypt certificate maintainer.

The bot updates the cetrificate when necessary. It doesn't directly communicate with the rest of the system and only contacts Let's Encrypt for the cetrificate and then saves the cetrificate for the nextcloud to use.

### 3.5 Clients
Connection over HTTPS, web browser and android app tested. 

## 4 Communication
	Communication channel between the modules. For instance, do the modules use secure communication to communicate with each other, if yes, how?

Already hinted in previous chapter

- server and client over HTTPS
	- how

- nextcloud and database over TLS (TLS_AES_256_GCM_SHA384)


## 5 Open source modules evaluation
	Pros and cons of the open-source components/modules used for developing the system, and the modules/components you have built (3 points)

*Open source is the way forward and any proprietary solution should be heavily build on open source. No need to keep reinventing wheel. (TBC reference based open source rant?)*

### 5.1 Nextcloud
pros:
- free and open source
- beginner-friendly basic setup
- can run very lightweight (e.g. on a RasPi) but also scale very large
- modular, can be extended with own or third-party extensions
- decent documentation
- auditability -  serves the privacy and security qualitative goal, as an end user can audit the system themself without requiring to put trust in third parties

cons:
- As everyone can see the code and put up their own systems, attacking it is easier. Attacks can be planned and tested without ever touching the target. For example some vulnerabilities might be found easier through reading the code and you don't have to worry about being found out when testing attacks, if you attack a system you yourself set up.

### 5.2 Let's Encrypt
pros:
- free
- very simple and quick
- only requires a short script to use

### 5.3 PostgreSQL
pros:
- free and open source

cons:
- not explicitly recommended for use with Nextcloud

### 5.4 Optional nss-ca
certificate chain generation and signing script. Based on widely used OpenSSL.
- good enough for personal usage
- openssl and crypto in general is not easy and user friendly
- cannot be trustworthy otherwise

Bla bla bla OpenSSL crap and ambiguous documentation etc.

## 6 Fallacies
	Which of the fallacies of the distributed system does your system violate, and how?

### 6.1 Network is reliable
- check if nextcoud mitigades e.g. upload interrupts / session resumption etc (I'd assume so since basic HTTPS config generally supports this on lower levels)

### 6.2 Latency is zero
- personal network (local), we do not care so much about the latency
- may be considered for self hosting somewhere and implementing e.g. WebRTC based audio/video chat

### 6.3 Infinite bandwidth
- This should be less of a problem for personal use
- TBC

### 6.4 Network is secure
Our system secures client communication with HTTPS and internal with TLS. Further consideration could be made to run the system in HSM based secure VM (e.g AMD-SEV/SNP, Intel TDX or Arm CCA in the future) or shifting the system to a container rather than VM and bootstrapping it with HSM (Intel SGX, RISC-V Keystone, TPM 2.0 etc.). This would secure internal communication and compute to the extent that even a physical access to the system would not reveal any sensitive information*.

*We're aware of side channel attacks vulnerabilities of mentioned systems and their are out of the scope of this project.

### 6.5 Topology doesn’t change
- TBC

### 6.6 There is one administrator
Nextcloud support multiple administrators, and further specified roles can be delegated to support customized administration topology. [\[NC-WP\]](#nc-wp)

The undelying OS (Ubuntu 20.04) can be as well configured to support multiple users with various administrative priviliedges. **(Some Reference here)**

### 6.7 Transport cost is zero
- TBC (I think a. for our use case of local network we can more or less asume this, b. in Finland the internet access is almost free so zero cost for our consumers?)

### 6.8 Network is homogeneous
The Nextcloud and our solution supports various communication protocols and APIs.

## 7 Further development
	What needs to be added to your system be used to be integrated/extended by another system.

### 7.1 Deployment
**Refactor needed**

Despite personal use as main target environment, it would be nice to have some kind of automated deployment script (Especially when things go sideways). From our experience the setup can be done quite quick, but it still is tedious and requires time and certain level of expertise. Definitely not for non-IT user / consumer.

Nextcloud maintains stable docker container configuration, which is a good place to start.

### 7.2 Federation
People on different servers can share files together. Though people still need to log into their own server, this can help extending the system and make communication between users of different servers possible.

### 7.3 Additional Services and Features
Nextcloud provides user friendly *app store* where once can pick from many available services (e.g. something something, voice channel)

Further WebDAV standard complient API gives an opportunity to indenpendently create custom services if one is of coding nature.

*Data storage connection to NAS-like system or at least raid-0 configuration of the system.*

### 7.X Others
- cetrificate: Cetrificate is needed for using https. For example Let's Encrypt is a service that can provide a cetrificate for an ip address. We used [acme-tiny](https://github.com/diafygi/acme-tiny)


## 8 Evaluation
	Methodology used for evaluating the system performance, and the key results

- hardware resource usage (idle and under load)
- latency, throughput / bandwidth?
- user experience testing

## 9 Conclusion / Learning

Nextcloud feels like a great DIY cloud playground.


## Resources
<a id="nc-wp">\[NC-WP\]</a> - Nextcloud Solution Architecture whitepaper. [Link](https://nextcloud.com/media/wp135098u/Architecture-Whitepaper-WebVersion-072018.pdf). Accessed 09.10.2021.
