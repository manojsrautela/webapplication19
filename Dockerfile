#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["WebApplication19/WebApplication19.csproj", "WebApplication19/"]
RUN dotnet restore "WebApplication19/WebApplication19.csproj"
COPY . .
WORKDIR "/src/WebApplication19"
RUN dotnet build "WebApplication19.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApplication19.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApplication19.dll"]