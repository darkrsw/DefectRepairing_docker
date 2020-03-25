FROM openjdk:8-jdk

RUN apt-get update && \
    apt-get install -y build-essential && \
    curl -L https://cpanmin.us | perl - App::cpanminus
RUN apt-get update && apt-get install maven

RUN git clone https://github.com/rjust/defects4j.git && git clone https://github.com/rohanpadhye/jqf && git clone https://github.com/jyi/DefectRepairing.git 

WORKDIR /defects4j
RUN git checkout tags/v1.3.0 -b right_ver

RUN cpanm --installdeps . && ./init.sh

ENV PATH="/defects4j/framework/bin:${PATH}"
CMD defects4j info -p Lang

RUN apt-get install -y python3-pip 
RUN  pip3 install unidiff


WORKDIR /DefectRepairing/tool/source



RUN make build

WORKDIR /DefectRepairing/tool

RUN cp -frap defects4j-mod/framework/ /defects4j

CMD defects4j info -p Lang


WORKDIR /jqf

RUN mvn package
