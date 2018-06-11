# MITREid Connect
---

This repo is a fork from the MITREid OpenID Connect project.

It includes SMART OAUTH functionality as well as Mckesson-centric implementations for Oracle 11g.

If you want to try the server on HSQL, you can run the openid-connect-server-webapp project by doing the following:

```terminal

$ mvn package <-- at the parent level
$ mvn clean deploy <-- at the parent level
$ cd openid-connect-server-webapp
$ mvn jetty:run

```

The Mckesson-openid-connect-webapp is the overlay project. To use it, do the following:

First, make sure the connection info is correct in /Users/angelo/OpenID-Connect-Java-Spring-Server/mckesson-openid-connect-webapp/src/main/webapp/WEB-INF/data-context.xml.

Also, check that your oracle username/password are correctly set in the file.

```bash
$ mvn package <-- at the parent level
$ mvn clean deploy <-- at the parent level
$ cd mckesson-openid-connect-webapp
$ mvn clean package
$ mvn jetty:run
```

If you need to create a new database in a running instance of Oracle, uncomment the lines at the bottom of data-context.xml that run the seed scripts. You may want to run the create_db-user file prior to running the seeds if you need the user and schema created. Be sure to comment those back out next time you run this. Another option would be to run the scripts manually.

```xml
<jdbc:initialize-database data-source="dataSource">
    <jdbc:script location="classpath:/db/oracle/oracle_database_tables.sql"/>
    <jdbc:script location="classpath:/db/oracle/security-schema_oracle.sql"/>
    <jdbc:script location="classpath:/db/oracle/loading_temp_tables_oracle.sql"/>
    <jdbc:script location="classpath:/db/oracle/users_oracle.sql"/>
    <jdbc:script location="classpath:/db/oracle/clients_oracle.sql"/>
    <jdbc:script location="classpath:/db/oracle/scopes_oracle11g.sql"/>
</jdbc:initialize-database>
```

Additionally, if you don't want to set environment variables, you can uncomment this (and fill in with your Oracle's server's information) in data-context.xml rather that use the connection url.:

Comment out this line:

```xml
<prop key="url">jdbc:oracle:thin:@//${OAUTH_JDBC_URL}</prop>
```

And uncomment these

```xml
<prop key="serverName">[your server ip]</prop>
<prop key="portNumber">1521</prop>
<prop key="driverType">thin</prop>
<prop key="databaseName">[dbname]</prop>
```

The server will be available at http://localhost:8080/openid-connect-server-webapp


Contributors to the McKesson version:

* [Tun Naing](https://github.com/naingtu/)
* [Angelo Kastroulis](https://github.com/angelok1/)

[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.mitre/openid-connect-parent/badge.svg)](https://maven-badges.herokuapp.com/maven-central/org.mitre/openid-connect-parent) [![Travis CI](https://travis-ci.org/mitreid-connect/OpenID-Connect-Java-Spring-Server.svg?branch=master)](https://travis-ci.org/mitreid-connect/OpenID-Connect-Java-Spring-Server)  [![Codecov](https://codecov.io/github/mitreid-connect/OpenID-Connect-Java-Spring-Server/coverage.svg?branch=master)](https://codecov.io/github/mitreid-connect/OpenID-Connect-Java-Spring-Server)

This project contains a certified OpenID Connect reference implementation in Java on the Spring platform, including a functioning [server library](openid-connect-server), [deployable server package](openid-connect-server-webapp), [client (RP) library](openid-connect-client), and general [utility libraries](openid-connect-common). The server can be used as an OpenID Connect Identity Provider as well as a general-purpose OAuth 2.0 Authorization Server.

[![OpenID Certified](https://cloud.githubusercontent.com/assets/1454075/7611268/4d19de32-f97b-11e4-895b-31b2455a7ca6.png)](https://openid.net/certification/)

More information about the project can be found:

* [The project homepage on GitHub (with related projects)](https://github.com/mitreid-connect/)
* [Full documentation](https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/wiki)
* [Documentation for the Maven project and Java API](http://mitreid-connect.github.com/)
* [Issue tracker (for bug reports and support requests)](https://github.com/mitreid-connect/OpenID-Connect-Java-Spring-Server/issues)
* The mailing list for the project can be found at `mitreid-connect@mit.edu`, with [archives available online](https://mailman.mit.edu/mailman/listinfo/mitreid-connect).


The authors and key contributors of the project include: 

* [Justin Richer](https://github.com/jricher/)
* [Amanda Anganes](https://github.com/aanganes/)
* [Michael Jett](https://github.com/jumbojett/)
* [Michael Walsh](https://github.com/nemonik/)
* [Steve Moore](https://github.com/srmoore)
* [Mike Derryberry](https://github.com/mtderryberry)
* [William Kim](https://github.com/wikkim)
* [Mark Janssen](https://github.com/praseodym)


Copyright &copy;2017, [MIT Internet Trust Consortium](http://www.trust.mit.edu/). Licensed under the Apache 2.0 license, for details see `LICENSE.txt`. 
