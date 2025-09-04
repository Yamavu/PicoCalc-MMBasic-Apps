#!/bin/python3

from pathlib import Path
from subprocess import check_call
from argparse import ArgumentParser

SUFFIXES_MUSIC = [".mp3", ".ogg", ".flac", ".aac", ".mp4", ".wav"]
SUFFIXES_IMAGE = [".jpg", "jpeg", ".png", ".bmp", ".webp"]
QUALITY = 128

FFMPEG = "ffmpeg"
IMAGEMAGICK = "magick"

def _call(parts):
    print(parts)
    #return
    check_call(parts)


def convert_music(p, outp):
    _call(
        [
            FFMPEG,
            "-i", str(p),
            "-map", "0:a:0",
            "-codec:a", "libmp3lame",
            "-b:a", f"{QUALITY}k",
            str(outp),
        ]
    )


def convert_image(p, outp):
    _call(
        [
            IMAGEMAGICK,
            str(p),
            "-resize", "180x180^",
            "-gravity", "center",
            "-crop", "180x180+0+0",
            "+repage",
            "-resize",
            "180x180",
            str(outp),
        ]
    )


def main(inputpath, outputpath):
    if not outputpath.exists():
        outputpath.mkdir(parents=True)
    track_nr = 1
    for p in inputpath.iterdir():
        if p.suffix not in SUFFIXES_MUSIC:
            continue
        outp = outputpath / f"{track_nr:02d}.mp3"
        convert_music(p, outp)
        track_nr = track_nr + 1
    for p in inputpath.iterdir():
        if p.suffix not in SUFFIXES_IMAGE:
            continue
        outp = outputpath / "album.bmp"
        convert_image(p, outp)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("input", type=Path, help="input folder with mp3s and an album image")
    parser.add_argument("output", type=Path, help="output folder, will be created if not exists")
    args = parser.parse_args()
    main(args.input, args.output)
