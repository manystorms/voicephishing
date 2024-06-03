import os
from time import sleep

result_filename = os.getenv("RESULT_FILENAME")
wav_filename = os.getenv("WAV_FILENAME")
r = ""

if not result_filename:
    print("RESULT_FILENAME is not set")
    exit(1)

#with open("ReadTxtTest.txt", 'r', encoding='utf-8') as file:
    #r = file.read()

if os.path.exists(wav_filename):
    with open(wav_filename, 'r', encoding='utf-8') as file:
            r = file.read()
else:
    r = "0"

with open(result_filename, "w") as f:
    f.write(r)
