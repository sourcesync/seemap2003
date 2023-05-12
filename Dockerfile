
from dustynv/l4t-pytorch:r35.1.0-pth1.13-py3

RUN python3 -m pip install fastai==2.7.10
RUN rm -fr /usr/lib/python3/dist-packages/numpy*
RUN python3 -m pip install numpy

CMD [ "/home/nano_start.sh" ]

ENTRYPOINT [ "/bin/bash" ]
