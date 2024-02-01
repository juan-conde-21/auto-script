FROM mcr.microsoft.com/dotnet/sdk:6.0

WORKDIR /dotnet-simple

RUN dotnet new web

COPY Program.cs .

COPY launchSettings.json /dotnet-simple/Properties/launchSettings.json

RUN dotnet build

#Export de variables Opentelemetry

ENV OTEL_TRACES_EXPORTER=otlp \
    OTEL_METRICS_EXPORTER=otlp \
    OTEL_LOGS_EXPORTER=otlp \
    OTEL_EXPORTER_OTLP_PROTOCOL=grpc \
    OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true \
    OTEL_DOTNET_AUTO_METRICS_CONSOLE_EXPORTER_ENABLED=true \
    OTEL_DOTNET_AUTO_LOGS_CONSOLE_EXPORTER_ENABLED=true

#Setup de Otel instrumentacion automatica

RUN apt-get update && apt-get install unzip
RUN mkdir /otel
RUN curl -L -o /otel/otel-dotnet-auto-install.sh https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/latest/download/otel-dotnet-auto-install.sh
RUN chmod +x /otel/otel-dotnet-auto-install.sh
ENV OTEL_DOTNET_AUTO_HOME=/otel
RUN /bin/bash /otel/otel-dotnet-auto-install.sh


#Ejecucion de app utilizando script de instrumentacion automatica

ENTRYPOINT ["/bin/bash", "-c", "source /otel/instrument.sh && dotnet run"]
