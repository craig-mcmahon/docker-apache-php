# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [1.5.0] - 2016-09-21
### Changed
- Moved from testing php7 alpine repo to community

### Added
- Apache mod_http2

## [1.4.1] - 2016-08-24
### Added
- Module pdo_sqlite
- Git

## [1.4.0] - 2016-08-24
### Changed
- PHP Version 7.0.10

### Added
- PHPUnit

## [1.3.1] - 2016-08-04
### Added
- PHP Phar module so we can actually use composer

## [1.3.0] - 2016-08-01
### Added
- Composer v1.2.0

### Changed
- PHP Version 7.0.9
- Apache Version 2.4.23

## [1.2.0] - 2016-07-05
### Removed
- Removed volume definitions, as mostly adding stuff into them in child Dockerfile's which causes issues

## [1.1.0] - 2016-06-29
### Added
- php module mcrypt

## 1.0.0 - 2016-06-10
### Added
- Initial commit
- PHP Version: 7.0.7
- Apache Version: 2.4.20
- OpenSSL Version: 1.0.2h

[Unreleased]: https://github.com/p13eater/docker-apache-php/compare/v1.5.0...HEAD
[1.5.0]: https://github.com/p13eater/docker-apache-php/compare/v1.4.1...v1.5.0
[1.4.1]: https://github.com/p13eater/docker-apache-php/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/p13eater/docker-apache-php/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/p13eater/docker-apache-php/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/p13eater/docker-apache-php/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/p13eater/docker-apache-php/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/p13eater/docker-apache-php/compare/v1.0.0...v1.1.0