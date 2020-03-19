FROM openjdk:7-jdk-jessie

RUN apt-get update && \
    apt-get install -y build-essential && \
    curl -L https://cpanmin.us | perl - App::cpanminus

RUN git clone https://github.com/rjust/defects4j.git /defects4j
    git checkout tags/v1.3.0 -b correct_ver
WORKDIR /defects4j

RUN cpanm --installdeps . && ./init.sh

ENV PATH="/defects4j/framework/bin:${PATH}"
CMD defects4j info -p Lang

RUN pip3 install unidiff

WORKDIR /
RUN git clone https://github.com/Ultimanecat/DefectRepairing.git
WORKDIR tool/source
RUN make build
WORKDIR ..
RUN cp -frap defects4j-mod/framework/ /defects4j

CMD defects4j info -p Lang

