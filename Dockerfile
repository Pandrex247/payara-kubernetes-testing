FROM azul/zulu-openjdk-alpine:11

ENV PAYARA_PATH /opt/payara

RUN mkdir -p $PAYARA_PATH/deployments && \
    adduser -D -h $PAYARA_PATH payara && echo payara:payara | chpasswd && \
    chown -R payara:payara /opt

RUN wget --quiet -O ${PAYARA_PATH}/payara-micro.jar https://repo1.maven.org/maven2/fish/payara/extras/payara-micro/5.194/payara-micro-5.194.jar
RUN wget --quiet -O ${PAYARA_PATH}/rest-jcache.war https://github.com/Pandrex247/payara-kubernetes-testing/blob/master/rest-jcache.war?raw=true

# Default payara ports to expose
EXPOSE 6900 8080

USER payara
WORKDIR $PAYARA_PATH

ENTRYPOINT ["java", "-jar", "payara-micro.jar", "--deploy", "rest-jcache.war", "--autobindhttp", "--clustermode", "kubernetes", "--name", "payara-micro"]
