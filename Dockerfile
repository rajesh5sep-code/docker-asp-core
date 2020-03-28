# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
# COPY *.sln .
COPY *.csproj ./todoapi/
WORKDIR /source/todoapi
RUN dotnet restore

# copy everything else and build app
COPY ./ ./todoapi
WORKDIR /source/todoapi
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
EXPOSE 80
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ToDoApi.dll"]