
from dustynv/l4t-pytorch:r35.1.0-pth1.13-py3

RUN python3 -m pip install fastai

CMD [ "/home/nano_start.sh" ]

ENTRYPOINT [ "/bin/bash" ]
