# docker-xe

[![Build Status](https://travis-ci.org/saltfactory/docker-xe.svg?branch=master)](https://travis-ci.org/saltfactory/docker-xe)
[![License](http://img.shields.io/badge/license-GNU%20LGPL-brightgreen.svg)](http://www.gnu.org/licenses/gpl.html)
[![Latest release](http://img.shields.io/github/release/saltfactory/docker-xe.svg)](https://github.com/saltfactory/docker-xe/releases)


**docker-xe**는 [XE(XpressEngine)](https://www.xpressengine.com/)을 docker에서 운영할 수 있는 컨테이너이다.


## XE(XpressEngine)

![XE](http://assets.hibrainapps.net/images/rest/data/498?size=full&m=1435845353)
<이미지 출처 : XpressEngine 공식사이트>

**XE**는 Naver 산하에 [GNU LGPL](https://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License) 오픈소스 프로젝트로 진행되고 있는 PHP 기반의 [CMS(Contents Management System)](https://ko.wikipedia.org/wiki/%EC%A0%80%EC%9E%91%EB%AC%BC_%EA%B4%80%EB%A6%AC_%EC%8B%9C%EC%8A%A4%ED%85%9C)이다. XE는 **제로보드(Zeroboard)**로 부터 진화하여 **제로보드XE** 까지 명칭이 변경되다가 CMS 기능이 단순 게시판 기능보다 더욱 강력하게 되면서 **board**라는 명칭을 없애고 **xE**라는 명칭을 가지게 되었다. **XE**는 모듈화 방식으로 발전하여 **XE-core**, **애드온**, **위젯**, **모듈**로 분리가 되며 각각 디자인을 다르게 관리할 수도 있어 확장성이 풍부하다.

## XE 요구사항

**XE**의 요구사항은 다음과 같다.

* PHP 5.3.0 이상
* php.ini의 `session_auto_start=Off` 설정
* XML 라이브러리
* GD 라이브러리
* ICONV
* MySQL 4.1 이상 (또는 MariaDB, MS-SQL, CUBRID)

## docker-xe

**docker-xe**는 *XE**를 docker 환경에서 운영하기 위한 컨테이너이다. 이것은 XE를 위해 서버에 복잡하게 웹 서버와 서버 설정을 하는 것을 생략하고 docker만 있다면 곧바로 실행하여 서비스를 할 수 있수 있다. docker-xe는 위에서 나열한 XE요구사항을 모두 적용할 뿐만 아니라 더 많은 라이브러리가 설치되어 있다.

* [Debian - jessie](https://www.debian.org/releases/stable/amd64/release-notes/) 운영체제
* Apache 2.4.10
* PHP 5.6.9
* XML 라이브러리 2.9.1
* GD 라이브러리 2.1.1
* ICONV 라이브러리 2.19
* MySQL 클라이언트 라이브러리 5.5.43 (PDO 버전 포함)
* 기타 라이브러리 지원

## docker-xe 쉘 인터피에스 사용방법

docker-xe는 docker의 사용을 더욱 편리하고 직관적으로 사용하기 위해서 shell 인터페이스 **shell/xe.sh**를 제공한다. shell 인터페이스는 **bash**를 사용한다. **Ubuntu**의 기본 쉘은 `dash`이다 `/bin/bash`로 쉘을 변경해서 아래와 같이 사용하면 된다.

```
/bin/bash shell/xe.sh build
```

이것은 파일에 실행권한을 줘서 좀 더 편리하게 사용할 수 있다.

```
chmod +x shell/xe.sh
```

실행권한을 부여하게 되면 다음과 같이 간단히 할 수 있다.

```
./shell/xe build
```

우리는 좀더 쉘 인터페이스를 편리하게 사용하기 위해서 다음과 같이 **alias**를 사용하기로 한다. 만약 docer-xe 경로가 `/demo/docker-xe`라면 다음과 같이 alias를 만든다.

```
alias xe='/demo/docker-xe/shell/xe'
```

## 설정 파일

docker-xe에 관한 설정 파일은 `shell/config.sh`로 이 파일에는 모든 설정 값을 지정할 수 있다. 아래는 기본적으로 제공하는 설정 값이다. docker-xe 이미지를 Mac OS X에서 진행하였기 때문에 volume을 지정하는 부분들이 boot2docker가 자동으로 마운트 시킬 수 있는 홈 디렉토리를 사용했다. linux 기반이라면 사용자가 필요에 따라 설정하면 된다.

```sh
############################################################
## docker project name
PROJECT_NAME="docker-xe"
############################################################
## docker configurations
DOCKER_USER="saltfactory"
DOCKER_VERSION="1.8.3"
DOCKER_NAME="xe"
DOCKER_IMAGE="$DOCKER_USER/$DOCKER_NAME:$DOCKER_VERSION"
############################################################
## container configurations
DOCKER_CONTAINER_NAME="demo-xe"
DOCKER_CONTAINER_PORT="7000"
############################################################
## container volumes
XE_HOME="/Users/saltfactory/shared/xe-core"
XE_FILES="/Users/saltfactory/shared/xe-core/files"
XE_LOGS="/Users/saltfactory/shared/logs"
############################################################
```

## docker-xe 이미지 빌드

docker-xe 이미지를 만들기 위해서 **xe** 쉘 인터페이스에 **build** 옵션을 사용한다. 기본적으로 다음과 같이 XE 풀 패키지를 자동으로 설치하여 빌드하게 된다.

```
xe build
```

만약 XE 소스를 docker-xe 외부에서 사용기 원한다면 소스빌드를 진행하면 된다.

```
./xe build src
```

## docker-xe 컨테이너 초기화

docker-xe를 성공적으로 빌드하면 초기 시작을 해야하는데 **xe** 쉘 인터페이스에 **init** 옵션으로 진행한다. 이 옵션은 빌드된 이미지를 사용하여 깨끗한 컨테이너를 최초로 실행하는 효과를 얻을 수 있다.

```
xe init
```

## docker-xe 컨테이너 시작

docker-xe 컨테이너가 생성된 이후 중지되었을 경우 **xe** 쉘 인터페이스에 **start** 옵션으로 진행한다. 이 옵션은 가장 마지막에 사용한 컨테이를 다시 실행시키기 때문에 **init**올 만든 깨끗한 커테이너와 다를 수 있다.

```
xe start
````

## docker-xe 컨테이너 재시작

docker-xe 컨테이너가 실행되고 있을 때 특별한 이유로 컨테이너를 다시 시작해야할 때 **xe** 쉘 인터페이스에 **restart** 옵션으로 진행한다.

```
xe restart
```

## docker-xe 컨테이너 중지

docker-xe 컨테이너가 실행되고 있을 때 중지하기 위해 **xe** 쉘 인터페이스 **stop** 옵션으로 진행한다. 컨테이너 동작이 멈췄을 뿐 컨테이너는 여전히 존재하고 있는 상태로 만든다.

```
xe stop
```

## docker-xe 컨테이너 삭제

docker-xe 컨테이너가 중지하고 있을 때 컨테이너를 완전히 삭제하기 위해 **xe** 쉘 인터페이스 **rm** 옵션으로 진행한다. 컨테이너가 멈춘 상태가 아닐경우는 컨테이너를 중지하고 컨테이너 삭제를 진행한다.

```
xe rm
```

## docker-xe 컨테이너 로그

docker-xe 컨테이너의 apache2의 로그는 내 컴퓨터 `./shell/config.sh` 파일에서 바로 확인할 수 있다.

```
xe logs
```

## 라이센스

**XE**는 GNU LGPL 오픈소스 라이센스 정책을 따르기 때문에 이 프로젝트 역시 GNU LGPL 라이센스를 적용한다.
