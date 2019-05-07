# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Added
- Standalone testbench for Z-70xx.

### Changed
- Pin IPApproX version for fully reproducible checkouts.
- Add support for Vivado 2018.3; our development now uses this version.  Remove support for Vivado
  2015.1, 2016.1, and 2016.3 since support for these versions was incomplete.

### Fixed
- Remove `apu_cluster` as it depends on components that are not available publicly.


## 1.0.0 - 2018-09-14

Initial public release
