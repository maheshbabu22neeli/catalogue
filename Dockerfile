#FROM node:20.20.2-alpine3.23 AS builder  # this doen't have any vulnerables to test from pipeline
# Hence, downgraded to lower version
FROM node:20.1.0-alpine AS builder
WORKDIR /app
COPY package.json .
COPY *.js .
RUN npm install


#FROM node:20.20.2-alpine3.23
FROM node:20.1.0-alpine
WORKDIR /app
EXPOSE 8080
COPY --from=builder /app /app
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
RUN chown -R roboshop:roboshop /app
USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]


#FROM node:20
#
#WORKDIR /app
#
#COPY package*.json ./
#COPY *.js ./
#
#RUN npm install
#
#ENV MONGO_URL="mongodb://mongodb:27017/catalogue" \
#    MONGO="true"
#
#CMD ["node", "server.js"]


