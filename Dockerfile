FROM eclipse-temurin:17-jdk AS builder

WORKDIR /build

COPY gradle/ gradle/
COPY gradlew gradlew.bat gradle.properties settings.gradle.kts build.gradle.kts ./
COPY swagger-coverage-commons/ swagger-coverage-commons/
COPY swagger-coverage-commandline/ swagger-coverage-commandline/
COPY swagger-coverage-rest-assured/ swagger-coverage-rest-assured/
COPY swagger-coverage-karate/ swagger-coverage-karate/

RUN chmod +x gradlew && \
    ./gradlew :swagger-coverage-commandline:installDist -x test --no-daemon

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /build/swagger-coverage-commandline/build/install/swagger-coverage-commandline/ .

ENTRYPOINT ["bin/swagger-coverage-commandline"]
