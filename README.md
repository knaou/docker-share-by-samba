Share by Samba
=================

## Introduction

Share files by using samba. 
Create one user for connection.

## Quick start

Bind 445/tcp and set volume mapping to /share.

    docker run -p 445:445 -v /home/somename:/share knaou/share-by-samba

And access \\ip-addr\share

## Full options

    WORKGROUP=WORKGROUP
    USER_ID=1000
    USER_NAME=samba
    PASSWORD=samba
    SHARE_NAME=share
    SHARE_DIR=/share

