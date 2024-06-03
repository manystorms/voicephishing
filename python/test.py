import os
import sys
from time import sleep

from op import add

result_filename = os.getenv("RESULT_FILENAME")
wav_filename = os.getenv("WAV_FILENAME")
res = ""

if not result_filename:
    print("RESULT_FILENAME is not set")
    exit(1)

# WAV 파일이 존재하고 확장자가 .wav인지 확인
#if os.path.exists(wav_filename) and wav_filename.lower().endswith('.wav'):
#    with open(wav_filename, 'rb') as file:
#            res = "1"
#else:
#    res = "0"

res = str(123)

with open(result_filename, "w") as f:
    f.write(res)
