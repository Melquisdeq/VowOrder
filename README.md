# VowOrder
<img width="217" height="56" alt="image" src="https://github.com/user-attachments/assets/c4cce96a-cefe-4b8f-9cea-f1cf252b659c" />

A WoW ascension CoA addon that reorders the Vow stance bar for the **Sun Cleric** class (Piety specialization), since the default stance bar order cannot be modified natively and places low-frequency abilities in high-priority slots.

## Why this addon exists

By default, the stance bar places **Vow of Light** in slot 2, an ability used infrequently during regular play. This makes the stance bar inefficient for quick access to the Vows actually used often in the Piety rotation.

This addon reorders the 5 stance bar slots as follows:

| Slot | Ability | Spell ID |
|------|---------|----------|
| 1 | Vow of Radiance | 803489 |
| 2 | Vow of Grace | 803719 |
| 3 | Vow of Dawn | 803491 |
| 4 | Vow of Light | 807547 |
| 5 | Vow of the Eclipse | 807435 |

## Requirements

- **[DragonUI](https://github.com/PentSec/DragonUI)** — this addon is built on top of DragonUI's stance bar implementation and hooks into its source code to reorder the bar. DragonUI must be installed and enabled for VowOrder to work.

## Installation

1. Download the latest release (zip) from the [Releases](../../releases) page.
2. Extract the folder into your WoW `Interface/AddOns` directory.
3. Make sure DragonUI is installed and enabled.
4. Enable **VowOrder** in your addon list.

## Compatibility

- Designed specifically for **Sun Cleric (Piety)**.
- Depends on DragonUI's stance bar structure — future DragonUI updates may require corresponding updates here.

## Notes

This addon was developed with AI assistance (Claude, Anthropic), including reading and understanding DragonUI's source code to implement the reordering logic.
