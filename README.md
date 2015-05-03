# mvn-get

mvn-get is a java toolkit for quickly checking and setting up library dependencies.

You can easily setup your prototype project or jsp project 's library dependencies **without .pom/.gradle file**.

## Installation

`gem install mvn-get`

## Usage

### mvn-get help

```
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ mvn-get help
Commands:
  mvn-get deps LIBRARY_NAME     # check dependencies of LIBRARY_NAME
  mvn-get help [COMMAND]        # Describe available commands or one specific...
  mvn-get install LIBRARY_NAME  # install all dependencies of LIBRARY_NAME
  mvn-get search LIBRARY_NAME   # search library call LIBRARY_NAME
```

### mvn-get install LIB_NAME 

```
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ mvn-get install unirest
Select library 'com.mashape.unirest:unirest-java:1.4.5'
Check dependencies...
16 Dependencies:
  avalon-framework:avalon-framework:4.1.5
  commons-codec:commons-codec:20041127.091804
  commons-logging:commons-logging:1.2
  javax.mail:mail:1.4.3
  javax.servlet:servlet-api:2.3
  junit:junit:3.8.1
  log4j:log4j:1.2.17
  logkit:logkit:1.0.1
  org.apache.geronimo.specs:geronimo-jms_1.1_spec:1.0
  org.apache.httpcomponents:httpasyncclient:4.0.2
  org.apache.httpcomponents:httpclient:4.3.6
  org.apache.httpcomponents:httpcore-nio:4.4.1
  org.apache.httpcomponents:httpcore:4.4.1
  org.apache.httpcomponents:httpmime:4.3.6
  org.apache.openejb:javaee-api:5.0-2
  org.json:json:20140107
Start downloading...
  [1/17] com.mashape.unirest:unirest-java:1.4.5
  [2/17] avalon-framework:avalon-framework:4.1.5
  [3/17] commons-codec:commons-codec:20041127.091804
  [4/17] commons-logging:commons-logging:1.2
  [5/17] javax.mail:mail:1.4.3
  [6/17] javax.servlet:servlet-api:2.3
  [7/17] junit:junit:3.8.1
  [8/17] log4j:log4j:1.2.17
  [9/17] logkit:logkit:1.0.1
  [10/17] org.apache.geronimo.specs:geronimo-jms_1.1_spec:1.0
  [11/17] org.apache.httpcomponents:httpasyncclient:4.0.2
  [12/17] org.apache.httpcomponents:httpclient:4.3.6
  [13/17] org.apache.httpcomponents:httpcore-nio:4.4.1
  [14/17] org.apache.httpcomponents:httpcore:4.4.1
  [15/17] org.apache.httpcomponents:httpmime:4.3.6
  [16/17] org.apache.openejb:javaee-api:5.0-2
  [17/17] org.json:json:20140107
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ ls
avalon-framework-4.1.5.jar         javaee-api-5.0-2.jar
commons-codec-20041127.091804.jar  json-20140107.jar
commons-logging-1.2.jar            junit-3.8.1.jar
geronimo-jms_1.1_spec-1.0.jar      log4j-1.2.17.jar
httpasyncclient-4.0.2.jar          logkit-1.0.1.jar
httpclient-4.3.6.jar               mail-1.4.3.jar
httpcore-4.4.1.jar                 servlet-api-2.3.jar
httpcore-nio-4.4.1.jar             unirest-java-1.4.5.jar
httpmime-4.3.6.jar
```

### mvn-get deps LIB_NAME 

```
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ mvn-get deps guava
Please specify a library, for example:
  com.github.ben-manes.caffeine:guava
  io.janusproject.guava:guava
  de.weltraumschaf.commons:guava
  com.google.guava:guava
  com.vaadin.external.google:guava
  io.janusproject.guava:guava-parent
  com.google.guava:guava-parent
  com.google.guava:guava-parent-jdk5
  com.googlecode.guava-osgi:guava-osgi
  net.javacrumbs.future-converter:java8-guava
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ mvn-get deps com.google.guava:guava
Select library 'com.google.guava:guava:18.0'
Check dependencies...
1 Dependencies:
  com.google.code.findbugs:jsr305:3.0.0
```

or specify library version

```
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ mvn-get deps com.google.guava:guava:15.0
Select library 'com.google.guava:guava:15.0'
Check dependencies...
2 Dependencies:
  com.google.code.findbugs:jsr305:3.0.0
  javax.inject:javax.inject:1
```

### mvn-get search LIB_NAME

```
honda@ubuntu:/var/lib/tomcat7/webapps/ROOT/WEB-INF/lib$ mvn-get search com.google.guava:guava
Candidates:
  com.google.guava:guava:18.0
  com.google.guava:guava:18.0-rc2
  com.google.guava:guava:18.0-rc1
  com.google.guava:guava:17.0
  com.google.guava:guava:17.0-rc2
  com.google.guava:guava:17.0-rc1
  com.google.guava:guava:16.0.1
  com.google.guava:guava:16.0
  com.google.guava:guava:16.0-rc1
  com.google.guava:guava:15.0
```

## Contributing

1. Fork it ( https://github.com/HondaDai/mvn-get/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
