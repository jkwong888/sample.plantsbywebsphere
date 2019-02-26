FROM registry.app311.ibmcase.cloudns.cx/ibmcom/websphere-liberty:javaee7-rhel

COPY ./pbw-ear/target/pbw-ear.ear /config/apps
COPY ./server.xml /config/server.xml
RUN mkdir /config/lib
COPY ./binary/lib/* /config/lib/

USER root

RUN mkdir -p /derby
RUN chown 1001:1001 /derby

ENV LICENSE accept


#USER root
#RUN /opt/ibm/wlp/bin/installUtility install --acceptLicense \
#  mpHealth-1.0

USER 1001

