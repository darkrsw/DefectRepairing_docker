FROM openjdk:8-jdk

RUN apt-get update && \
    apt-get install -y build-essential && \
    curl -L https://cpanmin.us | perl - App::cpanminus
RUN apt-get update && apt-get install -y maven && apt-get install -y vim

RUN git clone https://github.com/rjust/defects4j.git && git clone https://github.com/rohanpadhye/jqf && git clone https://github.com/jyi/DefectRepairing.git && git clone https://github.com/codespecs/daikon.git 

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

WORKDIR /daikon

RUN apt-get update && wget http://plse.cs.washington.edu/daikon/download/daikon-5.7.2.tar.gz && tar zxf daikon-5.7.2.tar.gz

RUN echo "export DAIKONDIR=/daikon/daikon-5.7.2" >> ~/.bashrc
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc

RUN make -C $DAIKONDIR rebuild-everything
WORKDIR /daikon
RUN make compile
RUN make doc-all
