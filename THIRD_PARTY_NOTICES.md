# Third-Party Notices

## Scope

This repository is a mixed-origin collection of configurations, scripts, themes,
and assets. Original authors and other copyright holders retain their rights.
The root [LICENSE](LICENSE) supplies the complete GNU General Public License,
version 3, for GPL-covered material and its local adaptations identified below.
It does not establish exclusive ownership of this collection, relicense separate
MIT or Apache-2.0 components, or grant rights in material of unknown provenance.

Existing copyright, author, source, license, and warranty notices within files
remain applicable. The credits below supplement rather than replace them and
are not an exhaustive list of contributors. A directory-level mapping describes
identified upstream material, not a blanket license determination for every file
in that directory. License texts and historical provenance must be checked when
individual files have additional or different origins.

## GPL-Covered Material

The following upstream repositories provide GNU GPL version 3 license text.
GPL-derived configurations and their local adaptations are distributed here
under version 3, with the full terms in [LICENSE](LICENSE).

| Upstream | Local Material and Evidence | Verified Upstream License |
| --- | --- | --- |
| [JaKooLit and contributors, Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) | JaKooLit-credited material in `config/waybar/` and `config/rofi/`, including module files, layouts, and themes. Other material demonstrably adapted from that project is subject to its applicable upstream notices. The separately identified Catppuccin palettes are MIT material. | [LICENSE.md at c093e836764d62346390ba307c9163ca11d0229b](https://github.com/JaKooLit/Hyprland-Dots/blob/c093e836764d62346390ba307c9163ca11d0229b/LICENSE.md) |
| [Aditya Shakya (adi1090x) and contributors, rofi](https://github.com/adi1090x/rofi) | Explicit credits in `config/rofi/themes/KooL_style-2-Dark.rasi`, `KooL_style-2-Light.rasi`, `KooL_style-3-Fullscreen-v2.rasi`, `KooL_style-4.rasi`, `KooL_style-7.rasi`, `KooL_style-14.rasi`, and `KooL_style-16-Modern.rasi`. JaKooLit and other existing credits are retained alongside this attribution. | [LICENSE at 512a585fff6da5b2a90e5948059b062516ddb2e7](https://github.com/adi1090x/rofi/blob/512a585fff6da5b2a90e5948059b062516ddb2e7/LICENSE) |
| [prasanthrangan and contributors, hyprdots](https://github.com/prasanthrangan/hyprdots) | Defaults in `config/kitty/hyde.conf` closely match the upstream [Kitty configuration](https://github.com/prasanthrangan/hyprdots/blob/3c8b0dfb5e7f8e41a67b80463513f10d57cab1a4/Configs/.config/kitty/kitty.conf). This is a provenance lead, not proof of an exact import revision or a license determination for every local Kitty file. Hyprdots-derived portions are GPLv3; the Oxocarbon theme is separately identified below. | [LICENSE at 3c8b0dfb5e7f8e41a67b80463513f10d57cab1a4](https://github.com/prasanthrangan/hyprdots/blob/3c8b0dfb5e7f8e41a67b80463513f10d57cab1a4/LICENSE) |

### GPL Version Precision

The checked root licenses establish GPL version 3, but do not unambiguously
establish a repository-wide choice between `GPL-3.0-only` and
`GPL-3.0-or-later` for the historical material imported here. The "or any later
version" wording in the standard license's instructional appendix is not by
itself a project-specific grant. GitHub's deprecated `GPL-3.0` label does not
resolve that question either.

Distribution under version 3 does not assert that upstream explicitly selected
"only", remove an existing later-version permission, or claim an unverified
later-version permission. Any verified file-specific license grant remains
applicable. See the FSF's [guidance on clear license
identification](https://www.gnu.org/licenses/identify-licenses-clearly.html).

## MIT Components

### Catppuccin

Copyright (c) 2021 Catppuccin

The four palette files in `config/waybar/style/catppuccin-themes/` derive from
[catppuccin/waybar](https://github.com/catppuccin/waybar). The local Mocha file
matches the upstream [Mocha CSS](https://github.com/catppuccin/waybar/blob/ee8ed32b4f63e9c417249c109818dcc05a2e25da/themes/mocha.css).
Catppuccin palette material also appears in
`config/rofi/themes/KooL_style-16-Modern.rasi`; that does not make the entire
GPL-derived Rofi theme MIT-licensed.

The complete MIT license, including the copyright and warranty disclaimer, is
reproduced in [licenses/Catppuccin-MIT.txt](licenses/Catppuccin-MIT.txt) from the
verified [Waybar upstream license](https://github.com/catppuccin/waybar/blob/ee8ed32b4f63e9c417249c109818dcc05a2e25da/LICENSE).
The [Catppuccin Rofi license](https://github.com/catppuccin/rofi/blob/main/LICENSE)
and [Catppuccin Kitty license](https://github.com/catppuccin/kitty/blob/main/LICENSE)
also use this MIT notice. The local Kitty theme is Oxocarbon, not Catppuccin.

### Oxocarbon

Copyright (c) 2025 Nyoom Engineering

`config/kitty/theme.conf` identifies itself as "Oxocarbon theme for Kitty".
[Nyoom Engineering's Oxocarbon project](https://github.com/nyoom-engineering/oxocarbon)
provides the verified MIT license reproduced in
[licenses/Oxocarbon-MIT.txt](licenses/Oxocarbon-MIT.txt).
It was fetched from
<https://raw.githubusercontent.com/nyoom-engineering/oxocarbon/main/LICENSE>;
the inspected revision is
[b9f45222b0cafb0da35e242ff8308df79148769d](https://github.com/nyoom-engineering/oxocarbon/blob/b9f45222b0cafb0da35e242ff8308df79148769d/LICENSE).

This preserves the verified current upstream notice, but the exact source and
revision of the local Kitty port have not been established. The 2025 notice does
not establish the creation date of the local file or rule out additional port
authors and notices. Those must be retained if identified.

## Apache-2.0 Exception

`config/nvim/` contains its own [Apache License, version 2.0](config/nvim/LICENSE).
Its Apache-2.0-covered material remains subject to that license and its existing
notices, rather than being blanket-relicensed by the root GPL text. Preserve
applicable copyright and attribution notices, identify modifications, and carry
forward any required upstream NOTICE material when redistributing it. The local
license copy does not constitute a complete audit of all Neovim configuration or
separately obtained plugins.

## Additional Existing Credits

Retain all credits in the source files, including those not listed here. The
inspected Waybar files additionally credit [Krautt](https://github.com/Krautt),
[mxkrsv](https://github.com/mxkrsv), [DevNChill](https://github.com/DevNChill),
[CelestiaKai](https://github.com/CelestiaKai), [0xl30](https://github.com/0xl30),
[prateekshukla1108](https://github.com/prateekshukla1108), and
[TomekBobrowicz](https://github.com/TomekBobrowicz).

The inspected Rofi files additionally credit Dave Davenport / DaveDavenport
(Qball), Rasmus Steinke, [newmanls](https://github.com/newmanls),
[lonerOrz](https://github.com/lonerOrz), [arkboix](https://github.com/arkboix/dotfiles),
and [JosephArmas](https://github.com/JosephArmas). In particular,
`config/rofi/themes/KooL_style-12-TOP-Docu.rasi` retains the explicit notice
`Copyright: Dave Davenport`.

These credits are not evidence that every credited contribution was originally
offered under the importing repository's root license. Additional source
licenses and notices may need to be recovered; this document neither replaces
them nor assumes authority to relicense those contributions.

## Local Adaptations

October 2026: the local collection includes adaptations to desktop configuration,
helper scripts, Waybar modules and layouts, Rofi themes, and Kitty settings.
These are local adaptations, not unmodified upstream releases. The original
credits remain applicable; this notice does not attribute the adaptations to
upstream authors or invent the identity of a local author.

For GPL-covered derivatives, the local adaptations are distributed under GNU
GPL version 3. Independent MIT and Apache-2.0 components retain their applicable
licenses and notices. This statement grants no rights beyond those available
from the relevant copyright holders. Retain accurate file-level modification
notices and dates where required; this collection-level notice is not a
substitute for recovering historical notices or a complete modification log.

## Unresolved Provenance

- `config/hyprlock/scripts/songdetail.sh` and the "Hyprlock Style 9" layout in `config/hyprlock/layouts/layout1.conf` lack established source/license provenance. Their presence and lack of headers do not establish local ownership or GPL/MIT permission.
- Redistribution rights and any attribution requirements for `wallpapers/profile.jpeg`, `wallpapers/winter-16.png`, and other independently sourced assets have not been established. They are not assigned the root GPL license by this document.
- Historical import commits and the exact license grants accompanying all imported versions have not been recorded or verified. Current upstream licenses are evidence for the cited revisions, not conclusive evidence of the terms for every older import or third-party contribution.
- The Kitty defaults' exact Hyprdots lineage and the Oxocarbon Kitty port's source, revision, and any additional authors remain to be established. Including the current upstream license texts does not resolve those historical questions.
- This is a representative attribution inventory, not a complete file-by-file rights clearance. Unknown or separately licensed material is not blanket-relicensed by this document or the root LICENSE.

Before redistributing material with unresolved rights, establish its source and
permission, obtain permission where needed, or exclude it. Including a license
text alone does not cure missing permission.
