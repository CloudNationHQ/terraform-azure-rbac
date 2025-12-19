# Changelog

## [2.4.3](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.4.2...v2.4.3) (2025-12-19)


### Bug Fixes

* pim resource assignments ([#70](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/70)) ([99434fd](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/99434fdfdb3c23ccf71dd83522ce15c8298237c6))

## [2.4.2](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.4.1...v2.4.2) (2025-11-28)


### Bug Fixes

* remove scope from builtin azurerm_role_definition data block ([#65](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/65)) ([7906986](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/7906986e8bd412932d1c12e6ff3f950430563dd7))

## [2.4.1](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.4.0...v2.4.1) (2025-11-10)


### Bug Fixes

* all upn references ([47c4e56](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/47c4e56f71635b53c4e54a6c7979f6bd859431e9))

## [2.4.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.3.1...v2.4.0) (2025-11-03)


### Features

* azurerm_role_management_policy ([#59](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/59)) ([a545529](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/a54552926a4a1a6c753f4988d6a8f880d9e65920))
* **deps:** bump github.com/cloudnationhq/az-cn-go-validor in /tests ([#58](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/58)) ([4bcb08e](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/4bcb08eefa733f53cece4871a38b6a8d144ae943))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#51](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/51)) ([fe0e96a](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/fe0e96a3cef2555929d287b7f964c0c52e5eb4ea))
* **deps:** bump golang.org/x/net in /tests in the go_modules group ([#48](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/48)) ([502d0a9](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/502d0a97d10b6153b1b0efe49c2fd266bab54153))

## [2.3.1](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.3.0...v2.3.1) (2025-07-24)


### Bug Fixes

* unknown values at runtime ([#52](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/52)) ([f56d6bf](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/f56d6bfd1fc689980232b9488bbc6ce4608f62ac))

## [2.3.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.2.0...v2.3.0) (2025-02-25)


### Features

* add some missing properties ([#45](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/45)) ([715c118](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/715c118b0fabea3f554bc9b1064f66ebd5ef9eb2))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#44](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/44)) ([ffbd6da](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/ffbd6daf9acd8d1ce931983940560455ec6a7690))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.1.0...v2.2.0) (2025-01-21)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#40](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/40)) ([2940ee3](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/2940ee3df7d7e2c07edf05100e51c62c5b02d93f))
* **deps:** bump the go_modules group in /tests with 2 updates ([#43](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/43)) ([33013f0](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/33013f0b0271917deba2ca90c400f99877369dad))
* improve testing ([#41](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/41)) ([ab8774a](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/ab8774afa5792894a13d8e7af81e42b49408f248))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v2.0.0...v2.1.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#37](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/37)) ([a0c19b0](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/a0c19b03f0f7de5c17eb63d10d9fa4cfedaea68c))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v1.1.0...v2.0.0) (2024-10-22)


### ⚠ BREAKING CHANGES

* upgrade azuread provider to v3 ([#35](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/35))

### Features

* upgrade azuread provider to v3 ([#35](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/35)) ([3bfdabd](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/3bfdabdca2f2f5b2f1422a0cc6f87d16e4b1b733))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v1.0.0...v1.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#33](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/33)) ([83852d2](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/83852d2061d496ce0e6eec57b991d6a241216fed))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#32](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/32)) ([92df37e](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/92df37ee1b8b7ece811059eed3ecab5da4546121))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.6.1...v1.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#30](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/30)) ([d1b4ff1](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/d1b4ff12757ba6aa5c25ad27d234965286fc9407))

### Upgrade from v0.6.1 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [0.6.1](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.6.0...v0.6.1) (2024-08-28)


### Bug Fixes

* fix capital markdown extensions ([#27](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/27)) ([98274c1](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/98274c18822661362dfa13b68c1b1ca6f578380d))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.5.0...v0.6.0) (2024-08-28)


### Features

* update documentation ([#25](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/25)) ([44c5366](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/44c5366f2a906fd97c00b3dc40e5ae0ad58d8fae))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.4.0...v0.5.0) (2024-08-22)


### Features

* added support for custom role definitions ([#23](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/23)) ([2ced7c2](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/2ced7c2d0f9fce483d93432ea65bad6ebeb5ba6e))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.3.0...v0.4.0) (2024-08-22)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#21](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/21)) ([dbb5605](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/dbb5605bfb3caadb07d78afd10380e91aee637e6))
* update contribution docs ([#18](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/18)) ([afe9fe9](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/afe9fe9fbefbfd98119528d9fb6df2afab273cb4))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.2.0...v0.3.0) (2024-07-02)


### Features

* add issue template ([#16](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/16)) ([2d0b7c5](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/2d0b7c5f106cc9f9d2215d1459d64724dceed77d))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#15](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/15)) ([0306011](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/0306011be155f509263689052a0af0b5995b2ce0))
* **deps:** bump github.com/hashicorp/go-getter ([#14](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/14)) ([1d350e3](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/1d350e3ed6cb3476bf9ccf409a6d68fc986b4c8c))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-rbac/compare/v0.1.0...v0.2.0) (2024-06-08)


### Features

* create pull request template ([#12](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/12)) ([6c8dbef](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/6c8dbefeb561b9c77604a3cde7ee959233be5650))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/11)) ([5de1a55](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/5de1a5557054f29bcf52c3eb60eaaa2ff3eb0283))
* **deps:** bump the go_modules group in /tests with 3 updates ([#9](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/9)) ([055de3e](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/055de3e58aca4fca09741c0e868a720659d260fc))

## 0.1.0 (2024-03-13)


### Features

* add initial resources, including readme, examples and tests ([999a8ce](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/999a8cee4d0ef83d193a244403d5c4c7f88a515c))
* add initial workflows ([539db58](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/539db58706458191850eb781e20b90862d741d72))
* cleanups ([7c282c6](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/7c282c63e0e239b94a2d58f813ffe1307e54f240))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#3](https://github.com/CloudNationHQ/terraform-azure-rbac/issues/3)) ([5e8b1d3](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/5e8b1d3db56d2679dcbc51a8ab4285c09d6189dc))
* minor adjustments ([4378497](https://github.com/CloudNationHQ/terraform-azure-rbac/commit/4378497eb71360ce50d0aa2d8e9f80e5a1d7a9a4))
