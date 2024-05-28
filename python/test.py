import os
from time import sleep

result_filename = os.getenv("RESULT_FILENAME")
wav_filename = os.getenv("WAV_FILENAME")
r = ""

if not result_filename:
    print("RESULT_FILENAME is not set")
    exit(1)

r = "asdfasdfasdf"

with open(result_filename, "w") as f:
    f.write(r)
