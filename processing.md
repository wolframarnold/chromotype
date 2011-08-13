.h2 How does PhotoStructure know what's import files and keep things synchronized?

PhotoStructure runs different kind of "harvesters" to keep the db in sync with reality.

.h4 Fast Harvester

This only processes the directories whose mtime != last_processed_mtime.

This is fairly cheap, but it doesn't find files that are updated.

.h4 Thorough Harvester

The thorough harvester doesn't skip any files -- it checks everything.

.h2 When do harvesters run?

When rails starts up, the nightly harvester is scheduled and a fast harvester is kicked off.

Photos are prioritized by 100 + (current time - mtime) (so newer photos are processed before older photos).