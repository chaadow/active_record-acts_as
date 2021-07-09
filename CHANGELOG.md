# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] -

### Fixed
- Handle kwargs in ruby 3 in methods delegated to supermodel.

## [5.0.1] - 2021-01-28

### Fixed
- Fixed rails `6.0.x` compatibility for `ActiveRecord::Errors` (@chaadow)

## [5.0.0] - 2020-12-29 by @chaadow

### Added
- Add support for rails 6 and 6.1 while removing rails 4.x and 5.x
  from the travis matrix.
- Remove last ruby 3 warnings and make the gem **totally compatible with
  ruby 3**
- Add support for rails master ( aka rails 6.2) to catch any upcoming
  breaking change up front.
- bump minimum ruby version to 2.5
- Update test coverage

### Fixed
- Fix `#touch` API to match rails 5/6 API and make it ruby 3 compatible
- collection methods such as `<<` work now under rails 6.1
- Prepare for Rails 6.2 breaking change by updating how errors
  are accessed and removing warning. They are now ruby objects.
  see [this](https://api.rubyonrails.org/v6.1.0/classes/ActiveModel/Errors.html)

### Removed
- Remove support for rails 4.x and 5.x

## [4.0.0] - 2019-01-09

## [3.1.0] - 2018-12-13

## [3.0.2] - 2018-08-12

## [3.0.1] - 2018-04-25

## [3.0.0] - 2019-02-21

## [2.5.0] - 2017-07-29
### Changed
- Drop support for Rails >= 5.0
- Remove warnings occurring in Rails 5.1

## [2.4.2] - 2017-04-20
### Fixed
- Fix querying for conditions with hashes.

## [2.4.1] - 2017-04-19
### Fixed
- Make ActiveRecord::Relation#where! work.

## [2.4.0] - 2017-04-16
### Changed
- Don't make all supermodel class methods callable by submodel, only scopes. Add `callable_by_submodel` to supermodel so users can make their own class methods callable by submodels.

## [2.3.1] - 2017-04-15
### Fixed
- Make calling supermodel class methods work through relations/associations as well

## [2.3.0] - 2017-04-12
### Fixed
- Prevent duplicate validation errors (fixes https://github.com/chaadow/active_record-acts_as/issues/2)

### Added
- Added support for touching submodel attributes (https://github.com/chaadow/active_record-acts_as/pull/3, thanks to [dezmathio](https://github.com/dezmathio)!)

## [2.2.1] - 2017-04-08
### Fixed
- Make sure submodel instance changes are retained when calling `submodel_instance.acting_as.specific`

## [2.2.0] - 2017-04-08
### Added
- Added support for calling superclass methods on the subclass or subclass relations

## [2.1.1] - 2017-03-22
### Fixed
- Fix querying subclass with `where`, for `enum` (and possibly other) attributes the detection whether the attribute is defined on the superclass or subclass didn't work.

## [2.1.0] - 2017-03-17
### Added
- Access superobjects from query on submodel by calling `.actables`

## [2.0.9] - 2017-03-02
### Fixed
- Fix handling of query conditions that contain a dot

## [2.0.8] - 2017-02-17
### Fixed
- Avoid circular dependency on destroy

## [2.0.7] - 2017-02-17 [YANKED]
### Fixed
- Set reference to submodel when building supermodel

## [2.0.6] - 2017-02-17
### Added
- Allow arguments to #touch and forward them to the supermodel

## [2.0.5] - 2016-12-20
### Fixed
- Don't try to touch supermodel if it's not persisted
- Call `#destroy`, not `#delete`, on the submodule by default to trigger callbacks

## [2.0.4] - 2016-12-07
### Fixed
- Touch associated objects if supermodel is updated

## [2.0.3] - 2016-11-07
### Fixed
- Fix defining associations on `acting_as` model after calling `acting_as`

## [2.0.2] - 2016-11-06
### Fixed
- Call `#touch` on `actable` object when it's called on the `acting_as` object

## [2.0.1] - 2016-10-05
### Added
- Added this changelog
- Added `touch` option to skip touching the `acting_as` object (https://github.com/hzamani/active_record-acts_as/pull/78, thanks to [allenwq](https://github.com/allenwq)!)

## [2.0.0] - 2016-09-14
### Added
- Added support for Rails 5 (https://github.com/hzamani/active_record-acts_as/pull/80, thanks to [nicklandgrebe](https://github.com/nicklandgrebe)!)
- Allow specifying `association_method` parameter (https://github.com/hzamani/active_record-acts_as/pull/72, thanks to [tombowo](https://github.com/tombowo)!)

### Removed
- Dropped support for Ruby < 2.2 and ActiveSupport/ActiveRecord < 4.2

### Fixed
- Fixed `remove_actable` migration helper (https://github.com/hzamani/active_record-acts_as/pull/71, thanks to [nuclearpidgeon](https://github.com/nuclearpidgeon)!)

[Unreleased]: https://github.com/chaadow/active_record-acts_as/compare/v5.0.0...HEAD
[5.0.0]: https://github.com/chaadow/active_record-acts_as/compare/v4.0.0...v5.0.0
[3.1.0]: https://github.com/chaadow/active_record-acts_as/compare/v3.1.0...v4.0.0
[3.0.2]: https://github.com/chaadow/active_record-acts_as/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/chaadow/active_record-acts_as/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/chaadow/active_record-acts_as/compare/v2.5.0...v3.0.0
[2.5.0]: https://github.com/chaadow/active_record-acts_as/compare/v2.4.2...v2.5.0
[2.4.2]: https://github.com/chaadow/active_record-acts_as/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/chaadow/active_record-acts_as/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/chaadow/active_record-acts_as/compare/v2.3.1...v2.4.0
[2.3.1]: https://github.com/chaadow/active_record-acts_as/compare/v2.3.0...v2.3.1
[2.3.0]: https://github.com/chaadow/active_record-acts_as/compare/v2.2.1...v2.3.0
[2.2.1]: https://github.com/chaadow/active_record-acts_as/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/chaadow/active_record-acts_as/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/chaadow/active_record-acts_as/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.9...v2.1.0
[2.0.9]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.8...v2.0.9
[2.0.8]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.7...v2.0.8
[2.0.7]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.6...v2.0.7
[2.0.6]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.5...v2.0.6
[2.0.5]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.4...v2.0.5
[2.0.4]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.3...v2.0.4
[2.0.3]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/chaadow/active_record-acts_as/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.8...v2.0.0
[1.0.8]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.0.rc...v1.0.0
[1.0.0.rc]: https://github.com/chaadow/active_record-acts_as/compare/v1.0.0.pre...v1.0.0.rc
