# [THE LEGEND OF ZELDA: LINK'S AWAKENING REDUX](https://www.romhacking.net/hacks/4672/)

-------------------

# **Index**

* [**The Legend of Zelda: Link's Awakening Redux Info**](#the-legend-of-zelda-links-awakening-redux)

* [**Changelog**](#changelog)

* [**Optional Patches**](#optional-patches)

* [**Usage**](#usage)

* [**How to contribute**](#how-to-contribute)

* [**Resources**](#resources)

* [**Credits**](#credits)

* [**Project Licence**](#license)

-------------------

## The Legend of Zelda: Link's Awakening Redux

Disassembly and source code recreation of the Link's Awakening Redux project based on the [Link's Awakening disassembly by ZLADX](https://github.com/zladx/LADX-Disassembly).

The Legend of Zelda: Link's Awakening Redux aims to some slight Quality of Life changes into the original GBC release.
This hack combines three of the most essential improvement hacks out there, and also implementing full uncensorship for Link's Awakening DX to make the game more enjoyable to play through.

Original Romhacking.net Release thread:
https://www.romhacking.net/hacks/4672/

-------------------

## Changelog

So what does this hack do specifically?

* Sprite and text uncensoring:
	- All sprites that were censored from the Japanese release have been restored
	- All text related to the censorship has been restored as well
	- Optional: Restore the low health beeping

* Link's Awakening DX VWF:
	- Introduces a Variable Width Font (VWF) that makes the text much more readable. 
	All the text is adapted to fit the space freed by the new font.
	- Removes the spaces at the end of the player’s name (if any) and fixes a couple of typos from the original game.

* Photo Album Translation:
	- Translation of the previously-untranslated Japanese present in the Photo Album.
	- Optional: Remove the Photo Album overlays, to have a clean image of each photograph.

* Quality of Life Improvements:
	- No more text when you touch certain objects. Rocks, cracked rocks, pots, ice blocks, etc.
	- Guardian Acorns and Pieces of Power are quick pickups. No more long text interrupting game play.
	- No more low health beeping.

* Bugfixes and other features:
	- Fix wrong warps (Randomizer)
	- Fix writting wrong room status (Doors in D7/D8 affect doors in D1-D6)  (Randomizer)
	- Reduce horse heads odds (1/2 chance instead of 1/4)  (Randomizer)
	- Allow a max of 3 firerod fires
	- Allow a max of two bombs to be placed
	- Allow a max of 3 arrows in the air
	- Reduced the delay between arrow shots
	- Allow the bridge photo with a follower (Randomizer)
	- Allow the photographer with Bow Wow saved (Randomizer)
	- Allow the Bow Wow photo with a follower (Randomizer)
	- Allow the Richard photo when the castle is opened (Randomizer)
	- Allow Richard photo without the Slime Key (Randomizer)


-------------------

## Optional patches

* Font Improvement (Optional):
NOTE: If you simply want a better font, but not have the Variable Width Font (VWF), then apply this patch first (don't patch the main Redux IPS)! So, if you want to use any optional patch:
Font Improvement -> Any other (Font Improvement ONLY) optional patch.
In short terms, this patch:
	- Removes VWF hack
	- Makes the font in Zelda - Link’s Awakening DX much more readable. 
	- Replaces the always-italics font from the original game with one that resembles the font used in the Zelda Oracles series.

* Remove the THIEF photo downsides (Optional):
	NOTE: There's two patches for this. One that says "Normal Redux ONLY" and another that says "Font Improvement ONLY".
	Remove the THIEF photo punishment, meaning that you won't get your character named THIEF for obtaining the thief photo. The Death counter won't go up when the shopkeeper kills you for that pic as well. There's two patches for this, similar to the Low Beep one:
	- Normal Redux ONLY: Apply this patch only if you will be using Redux normally WITHOUT the "Font Improvement" patch. Apply main Redux IPS patch first, then the "Remove THIEF Photo Downsides (Normal Redux ONLY).ips" patch secondly.
	- Font Improvement ONLY: Apply this patch only if you will be using Redux patched alongside the Font Improvement hack. Apply the "Font Improvement.ips" patch first, then the "Remove THIEF Photo Downsides (Font Improvement ONLY).ips" patch secondly.

* Restore the low health beeping (Optional):
	NOTE: There's two patches for this. One that says "Normal Redux ONLY" and another that says "Font Improvement ONLY".
	- Normal Redux ONLY: Apply this patch only if you will be using Redux normally WITHOUT the "Font Improvement" patch. Apply main Redux IPS patch first, then the "Restore Low Health Beep (Normal Redux ONLY).ips" patch secondly.
	- Font Improvement ONLY: Apply this patch only if you will be using Redux patched alongside the Font Improvement hack. Apply the "Font Improvement.ips" patch first, then the "Restore Low Health Beep (Font Improvement ONLY).ips" patch secondly.

* Change save button combo (Optional):
	- These set of patches modify the button combo required to manually save in-game. The game originally required you to press A+B+Select+Start in order to bring up the Save menu. With these set of patches, you can easily choose whichever button combo you want, and apply it over your Redux ROM to easily access the Save menu with the button combo of your choice! (My preferred one is A+Select).

-------------------

It builds the following ROMs:

- azlj.gbc (Japanese, v1.0) `
md5: f75874e3654360094fc2b09bd1fed7e8`
- azlj-r1.gbc (Japanese, v1.1) `
md5: 6d8f9cd72201caabdfd0455a819af9ce`
- azlj-r2.gbc (Japanese, v1.2) `
md5: 2e2596c008d47df901394d28f5bd66ec`
- azle.gbc (English, v1.0) `
md5: 07c211479386825042efb4ad31bb525f`
- azle-r1.gbc (English, v1.1) `
md5: ccbb56212e3dbaa9007d389a17e9d075`
- azle-r2.gbc (English, v1.2) `
md5: 7351daa3c0a91d8f6fe2fbcca6182478`
- azlg.gbc (German, v1.0) `
md5: e91fd46e7092d32ca264f21853f09539`
- azlg-r1.gbc (German, v1.1) `
md5: b0080c2f1919a4bb0ea73b788f4a6786`
- azlf.gbc (French, v1.0) `
md5: 1043fd167d0ed9c4094e3c9d8e757f1e`
- azlf-r1.gbc (French, v1.1) `
md5: 68242187b65166b5f8225b20e2021659`

Additionally, a wiki includes a [high-level overview of the game engine](https://github.com/zladx/LADX-Disassembly/wiki/Game-engine-documentation), and technical informations on the [data formats used](https://github.com/zladx/LADX-Disassembly/wiki/Maps-data-format) throughout the game.

-------------------

## Usage

1. Install Python 3 and [rgbds](https://github.com/gbdev/rgbds#1-installing-rgbds) (version >= 1.0.0 required);
2. `make all`.

This will build both the games and their debug symbols. Once built, use [BGB](https://github.com/zladx/LADX-Disassembly/wiki/Tooling-for-reverse-engineering#bgb) to load the debug symbols into the debugger.

-------------------

## How to contribute

1. Fork this repository;
2. Find a little piece of code to improve:
  - Maybe a typo, a missing constant, an obvious label that could be renamed;
  - Or start following a thread (Link's animations? The island fade-out special effect? Trading items constants?) and document some details along your read;
  - You can also look at the [known improvements](https://github.com/zladx/LADX-Disassembly/issues) – especially [good first issues](https://github.com/zladx/LADX-Disassembly/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22good+first+issue%22);
3. Submit a pull request.

Having questions, or do you need help? Join the discussion on [Discord](https://discord.gg/sSHrwdB).
You can also read [disassembling How-Tos](https://github.com/zladx/LADX-Disassembly/wiki) in the Wiki, for some infos about the tools and disassembling processes.

-------------------

## Resources

- [Artemis251's Link's Awakening Cache](http://artemis251.fobby.net/zelda/index.php): ROM map, maps data format
- [Xkeeper's Link's Awakening depot](https://xkeeper.net/hacking/linksawakening/): maps tilesets and save format infos
- [LALE](https://github.com/anotak/LALE): level editor, notes on maps data format
- [The Legend of Zelda Link's Awakening /DX Speedrunning Wiki](http://spiraster.x10host.com/LADXWiki/index.php/) : infos on wrong warps and map data format
- [Zelda III Disassembly](http://www.zeldix.net/t143-disassembly-zelda-docs) ([archive](https://web.archive.org/web/20180315181518/http://www.zeldix.net/t143-disassembly-zelda-docs)): good source on Zelda SNES source code, which has many similarities to LADX
- [Disassembling Link's Awakening](https://zladx.github.io): a series of blog posts and progress reports
- Discord: [LADX](https://discord.gg/sSHrwdB)

-------------------

## Credits

Thanks to these people for contributing:

Link's Awakening Redux:
* toruzz - [Link's Awakening DX VWF version](https://www.romhacking.net/hacks/2414/)
* vince94 - [Photo Album Translation](https://www.romhacking.net/hacks/2361/)
* IcePenguin - [Quality of Life Improvements](https://www.romhacking.net/hacks/3597/)
* Tzepish - [Font Improvement hack](https://www.romhacking.net/hacks/927/)
* Daid - [LADX Randomizer](https://github.com/daid/LADXR)
* Jayro - [Script and header fixes](https://gbatemp.net/download/the-legend-of-zelda-links-awakening-dx-redux.37295/)

Link's Awakening DX Disassembly:
* mojobojo - https://github.com/mojobojo
* kemenaran - https://github.com/kemenaran
* Drenn1 - https://github.com/Drenn1
* Sanqui - https://github.com/Sanqui
* Kyle McGuffin - https://github.com/kcmcg
* Marijn van der Werf - https://github.com/marijnvdwerf
* samuel-flynn - https://github.com/samuel-flynn
* Xkeeper - https://github.com/Xkeeper0
* Vextrove - https://github.com/Vextrove
* daid - https://github.com/daid
* stephaneseng - https://github.com/stephaneseng
* zelosos - https://gitlab.com/zelosos
* tobiasvl - https://github.com/tobiasvl

([See contribution details here](https://github.com/zladx/LADX-Disassembly/graphs/contributors))
