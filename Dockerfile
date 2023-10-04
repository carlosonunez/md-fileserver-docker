FROM node:16-alpine
ARG VERSION
RUN npm install -g "md-fileserver@$VERSION"
ENTRYPOINT [ "mdstart" ]
