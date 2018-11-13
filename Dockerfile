FROM openjdk:8-jdk-alpine

ENV PAYARA_PATH /opt/payara

RUN   apk update \                                                                                                                                                                                                                        
 &&   apk add ca-certificates wget \                                                                                                                                                                                                      
 &&   update-ca-certificates && \
 mkdir -p $PAYARA_PATH/deployments && \
 adduser -D -h $PAYARA_PATH payara && echo payara:payara | chpasswd && \
 chown -R payara:payara /opt

RUN wget --quiet -O ${PAYARA_PATH}/payara-micro.jar https://github.com/Pandrex247/payara-kubernetes-testing/blob/master/payara-micro-5.184.jar?raw=true
RUN wget --quiet -O ${PAYARA_PATH}/rest-jcache.war https://github.com/Pandrex247/payara-kubernetes-testing/blob/master/rest-jcache.war?raw=true

# Default payara ports to expose
EXPOSE 4848 8009 8080 8181

USER payara
WORKDIR $PAYARA_PATH

ENTRYPOINT ["java", "-jar", "payara-micro.jar", "--deploy", "rest-jcache.war", "--autobindhttp", "--clustermode", "kubernetes:default,payara-micro", "--name", "payara-micro"]
