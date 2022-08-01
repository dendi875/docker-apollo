FROM maven:alpine

# 改动自  https://github.com/foxiswho/docker-apollo

MAINTAINER quanzhang875 <quanzhang875@gmail.com>

ENV VERSION=1.1.0 \
    PORTAL_PORT=8070 \
    ADMIN_DEV_PORT=8090 \
    ADMIN_FAT_PORT=8091 \
    ADMIN_UAT_PORT=8092 \
    ADMIN_PRO_PORT=8093 \
    ADMIN_DOCKER_PORT=8094 \
    CONFIG_DEV_PORT=8080 \
    CONFIG_FAT_PORT=8081 \
    CONFIG_UAT_PORT=8082 \
    CONFIG_PRO_PORT=8083 \
    CONFIG_DOCKER_PORT=8084

ARG APOLLO_URL=https://github.com/ctripcorp/apollo/archive/v${VERSION}.tar.gz


COPY docker-entrypoint /usr/local/bin/docker-entrypoint

# 下面的包是通过修改源码，加入了自定义环境 docker
ADD apollo-portal-${VERSION}-github.zip /
ADD apollo-adminservice-${VERSION}-github.zip /
ADD apollo-configservice-${VERSION}-github.zip /


RUN cd / && \
    mkdir /apollo-admin/dev /apollo-admin/fat /apollo-admin/uat /apollo-admin/pro /apollo-admin/docker -p && \
    mkdir /apollo-config/dev /apollo-config/fat /apollo-config/uat /apollo-config/pro /apollo-config/docker -p && \
    mkdir /apollo-portal -p && \
    unzip -o /apollo-adminservice-${VERSION}-github.zip -d /apollo-admin/dev && \
    unzip -o /apollo-configservice-${VERSION}-github.zip -d /apollo-config/dev && \
    unzip -o /apollo-portal-${VERSION}-github.zip -d /apollo-portal && \
    sed -e "s/db_password=/db_password=root/g"  \
            -e "s/^local\.meta.*/local.meta=http:\/\/localhost:${PORTAL_PORT}/" \
            -e "s/^dev\.meta.*/dev.meta=http:\/\/localhost:${CONFIG_DEV_PORT}/" \
            -e "s/^fat\.meta.*/fat.meta=http:\/\/localhost:${CONFIG_FAT_PORT}/" \
            -e "s/^uat\.meta.*/uat.meta=http:\/\/localhost:${CONFIG_UAT_PORT}/" \
            -e "s/^pro\.meta.*/pro.meta=http:\/\/localhost:${CONFIG_PRO_PORT}/" \
            -e "s/^docker\.meta.*/docker.meta=http:\/\/localhost:${CONFIG_DOCKER_PORT}/" -i /apollo-portal/config/apollo-env.properties && \
    cp -rf /apollo-admin/dev/scripts /apollo-admin/dev/scripts-default  && \
    cp -rf /apollo-config/dev/scripts /apollo-config/dev/scripts-default  && \
    cp -rf /apollo-admin/dev/*  /apollo-admin/docker/  && \
    cp -rf /apollo-config/dev/* /apollo-config/docker/  && \
    cp -rf /apollo-admin/dev/* /apollo-admin/uat/  && \
    cp -rf /apollo-admin/dev/* /apollo-admin/pro/  && \
    cp -rf /apollo-config/dev/* /apollo-config/uat/  && \
    cp -rf /apollo-config/dev/* /apollo-config/pro/ && \ 
    rm -rf *zip && \
    chmod +x  /usr/local/bin/docker-entrypoint

EXPOSE 8070 8080 8081 8082 8083 8084 8090 8091 8092 8093 8094
# EXPOSE 80-60000

ENTRYPOINT ["docker-entrypoint"]
