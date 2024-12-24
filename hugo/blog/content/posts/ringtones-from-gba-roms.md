+++
title = "Project notes: getting playable audio files out of a .gba rom"
date = 2024-10-06
author = ["josiah"]
draft = false
+++

I want to have, say, a ring tone from megaman battle network 3 blue, somehow. I don’t know what i want exactly, but something from that game. I own the game 8 times over, surely there's a way to do this.


## Outline {#outline}

1.  How do I get the files from the .gba file itself?
    1.  This is apparently annoying and lossy, but `vgmtrans` ~works.
    2.  I was suggested several other options but they require manually editing makefiles and compiling c++, gross, lets skip those.
2.  `VGMtrans` is pretty self explantory, poke around the UI to find the files you want. You’ll have to play every sound collection in there to know what they are though.
3.  Export all your files in various formats to your file system, again, just in the UI.
4.  Next, a digression into how the resultant audio files work:
    1.  `.MID` files are midi files, which contain music _sequences_ but no _sound_.
    2.  `DLS` is a “downloadable sounds” file, which contains sound samples that can be used by MIDI
    3.  `SF2` is a soundfount file, basically an alternative to DLS.
    4.  Probably you only need either DLS or SF2 at a single time, just depends on what’s supported by the DAW you’ll be working with in next step
5.  Now you have all the bare files exported, but you need to recombine them into a file that your phone can understand.
    1.  `LMMS` is free / open source. There’s better options, but not without a price tag.
    2.  `LMMS` works, I did an original POC with it, but its not easily automatable. But! There is something that IS automatiable on the commandline called  `fluidsynth`  that gets us alllllmost all the way there - it can give us `.wav` files.
    3.  Once you have a `.wav` its easy to use ffmpeg to get `.mp3`


## Conversion script {#conversion-script}

I llm’d a script to do this for me en masse:

```python
import os
import subprocess
import pdb

# Directory where your files are located
root = "/Users/josiah/mmbn3/"
export_dir = root + "exports"
directory = root + "raws"

# Go through each MIDI file and find its matching SF2 file
for file in os.listdir(directory):
    if file.endswith(".mid"):
        midi_file = os.path.join(directory, file)
        sf2_file = os.path.join(directory, file.replace(".mid", ".sf2"))

        if os.path.exists(sf2_file):
            # Output WAV file name
            output_wav = os.path.join(export_dir, file.replace(".mid", ".wav"))
            output_mp3 = os.path.join(export_dir, file.replace(".mid", ".mp3"))

            # Run Fluidsynth to combine the files and export to WAV
            subprocess.run([
                "fluidsynth", "-ni", sf2_file, midi_file, "-F", output_wav
            ])
            subprocess.run([
                "ffmpeg", "-i", output_wav, output_mp3
            ])

            # Delete the WAV file after MP3 is successfully created
            if os.path.exists(output_mp3):
                os.remove(output_wav)
                print(f"Deleted intermediate file: {output_wav}")
            print(f"Processed {file} -> {output_mp3}")

```


## iphone idiocy {#iphone-idiocy}

You’d think you’d be done, simply import them to your phone and bam you got ring tones!

Wrong.

On iPhone, for historic “we sell ringtones” reasons, its still very annoying to get a sound file to be recognized by the system as appropriate for ring tone useage.

1.  Put your files on icloud drive somewhere
2.  Open garageband on your phone
3.  Create a new project with the `audio recorder` option
4.  Import your audio file
    1.  Tap the `loop` icon in the top right
    2.  Go to the weird loop thing on the top right
    3.  `browse items from the files app`
5.  Trim audio as needed
6.  Tap the `down arrow` in the top left, select “my songs” and then select from storage, import the specific file.
    1.  Tap on the song song you’ve just created
    2.  The select share
    3.  Choose ringtone.
7.  Now assign as default ringtone in settings, or per contact


## Problems with this approach {#problems-with-this-approach}

This has worked mostly well! But there's a few things that are sub-optimal that i haven't figured out:

1.  There's definitely some sound effects I can't find. Probably that's weirdness in the import process to vgmtrans, but no idea what i can do about it
2.  Despite exporting the sf2 files, the sounds are just a bit off when it comes to the soundtrack - the midi file / sequence definitely works, but the instruments must be subtly different.
    1.  I'm tempted to try remixing all the files with DLS instead of sf2 and see if it changes the output, but i'm out of time today :|
3.  I haven't figured out a bulletproof way to have notifications on iPhone setup the way i want
    1.  Apple watches mess with your notification scheme, both individually per app and globally with the `silent` option.
