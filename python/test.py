import os
import sys
from time import sleep

import speech_recognition as sr

result_filename = os.getenv("RESULT_FILENAME")
wav_filename = os.getenv("WAV_FILENAME")
res = ""

if not result_filename:
    print("RESULT_FILENAME is not set")
    exit(1)

try:
    r = sr.Recognizer()
    harvard = sr.AudioFile(wav_filename)
    with harvard as source:
      audio = r.record(source) # .wav파일을 오디오 데이터 인스터스로

    res = r.recognize_google(audio, language='ko-KR')
except Exception as e:
    res = str(e)

with open(result_filename, "w") as f:
    f.write(res)