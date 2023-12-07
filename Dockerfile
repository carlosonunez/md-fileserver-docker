FROM node:16-alpine
ARG VERSION
RUN npm install -g "md-fileserver@$VERSION"
COPY ./entrypoint.sh /entrypoint
RUN chmod 755 /entrypoint
ENTRYPOINT [ "/entrypoint" ]
