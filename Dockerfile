FROM python:slim

WORKDIR /
# Deps
RUN if [ "$(uname -m)" = "aarch64" ] ; then \
        export HOST_CPU_ARCH=arm64; \
    elif [ "$(uname -m)" = "x86_64" ]; then \
        export HOST_CPU_ARCH=amd64; \
    fi && \
    sed -i 's/main/main non-free/g' /etc/apt/sources.list && \
    apt-get -qq update && \
     mkdir /app/ && chmod 777 /app/
RUN pip3 install --upgrade pip setuptools

# copy the dependencies file to the working directory
COPY requirements.txt .

# install dependencies
#RUN pip install -r requirements.txt
# install dependencies
#RUN pip3 install --no-cache-dir tgfilestream

# copy the content of the local src directory to the working directory
COPY . .
RUN pip3 install --no-cache-dir requirements.txt

RUN apt-get purge -yqq gcc && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && apt-get clean
# Starting Worker
CMD ["python3","-m","tgfilestream"]

EXPOSE 8080
