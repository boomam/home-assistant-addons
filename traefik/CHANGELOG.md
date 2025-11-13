# Change Log
## Updates
Traefik version should automatically update through a GitHub Action.
Base Image will be a manual process for the time being.

## Versioning
First three digits are Traefik's version number.  
The letter & number are bug fix releases where said issue is not with Traefik, but with this template.  

-----
## Traefi 3.6.1
* Updated base image from 18.1.3 to 18.2.1
* Updated Traefik from 3.6.0 to 3.6.1

## Traefik 3.6.0
* Updated Traefik from 3.5.4 to 3.6.0

## Traefik 3.5.4
* Updated Traefik from 3.5.3 to 3.5.4

## Traefik 3.5.3
* Updated Traefik from 3.5.2 to 3.5.3
* Updated base image from v18.1.0 to 18.1.3

## 3.5.2
### 3.5.2.a
* Updated Traefik from 3.5.1 to 3.5.2
* Updated base image from v18.1.0 to 18.1.1

## 3.5.1
### 3.5.1.b
* Added `insecure_skip_verify` option - Thank you to [@lalexdotcom](https://github.com/lalexdotcom)

### 3.5.1.a
* Updated Traefik from 3.5.0 to 3.5.1
* Updated base image from v18.0.3 to 18.1.0

## 3.5.0
### 3.5.0.a
* Updated Traefik from 3.3.4 to 3.5.0
* Updated base image from v17.2.2 to 18.0.3

## 3.3.4
### 3.3.4.h
* sidebar fix testing.

### 3.3.4.e
* Adjusted sidebar streaming to help with rendering of traefik dashboard through sidebar.

### 3.3.4.c
* Fixed log level issues with (most) log levels.
* Edited base template for LE to include all needed variables for CF.
  
### 3.3.4.b
* Fixed `Unknown Level String` when setting log level.
* Added 8080/tcp to ports to allow direct access to Traefik Dashboard (http://IP_Address:8080/dashboard/)
* Added notes and references to original fork/dev.

### 3.3.4.a
* Updated docs and guidance that displays in HA.
* Updated references to old repo.
* Updated name of entrypoints to match Traefik default standards.

## 3.3.4 (Initial Release)
* 📈 Traefik v3.3.4
* 📈 HASSIO Base v17.2.2
* Change Log versioning changed to match upstream Traefik versioning.
