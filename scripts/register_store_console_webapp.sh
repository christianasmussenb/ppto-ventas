#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONTAINER_NAME="${IRIS_CONTAINER_NAME:-iris111}"
WEB_APP_NAME="/csp/store-console"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required to register the store console web app" >&2
  exit 1
fi

cat <<'EOS' | docker exec -i -u irisowner "${CONTAINER_NAME}" bash -s
cat >/home/irisowner/store-console.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<ApplicationsExport>
  <Applications>
    <AutheEnabled>32</AutheEnabled>
    <AutoCompile>false</AutoCompile>
    <CookiePath>/csp/store-console/</CookiePath>
    <CorsCredentialsAllowed>true</CorsCredentialsAllowed>
    <CSPZENEnabled>true</CSPZENEnabled>
    <CSRFToken>false</CSRFToken>
    <DeepSeeEnabled>false</DeepSeeEnabled>
    <Description>Monitoring REST Apis</Description>
    <DispatchClass>API.UIController</DispatchClass>
    <Enabled>true</Enabled>
    <HyperEvent>0</HyperEvent>
    <iKnowEnabled>false</iKnowEnabled>
    <InbndWebServicesEnabled>false</InbndWebServicesEnabled>
    <IsNameSpaceDefault>false</IsNameSpaceDefault>
    <JWTAuthEnabled>false</JWTAuthEnabled>
    <JWTAccessTokenTimeout>60</JWTAccessTokenTimeout>
    <JWTRefreshTokenTimeout>900</JWTRefreshTokenTimeout>
    <LockCSPName>true</LockCSPName>
    <Name>/csp/store-console</Name>
    <NameSpace>USER</NameSpace>
    <Recurse>true</Recurse>
    <RedirectEmptyPath>true</RedirectEmptyPath>
    <ServeFiles>1</ServeFiles>
    <ServeFilesTimeout>3600</ServeFilesTimeout>
    <Timeout>3600</Timeout>
    <TwoFactorEnabled>false</TwoFactorEnabled>
    <Type>2</Type>
    <UseCookies>2</UseCookies>
    <SessionScope>2</SessionScope>
    <UserCookieScope>2</UserCookieScope>
    <WSGICallable>app</WSGICallable>
    <WSGIDebug>false</WSGIDebug>
    <WSGIType>1</WSGIType>
    <Version>3</Version>
  </Applications>
</ApplicationsExport>
XML

/home/irisowner/bin/iris session IRIS -U %SYS <<'IRISEOF'
Set app=""
Set exists=##class(Security.Applications).Exists("/csp/store-console",.app)
If exists Set sc=##class(Security.Applications).Delete("/csp/store-console")
If exists Write $SYSTEM.Status.GetErrorText(sc),!
Set n=0
Set sc=##class(Security.Applications).Import("/home/irisowner/store-console.xml",.n,0)
Write $SYSTEM.Status.GetErrorText(sc),!
Write n,!
Halt
IRISEOF
EOS

echo "Store console web app registered at ${WEB_APP_NAME}"