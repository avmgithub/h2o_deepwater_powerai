FROM avmdocker/ibmmldlh2odw_r4:01
#FROM jarvice/ubuntu-ibm-mldl-ppc64le:latest

# uprev to force rebuild even if cached
ENV APP_POWERAI_VERSION 1

ADD https://raw.githubusercontent.com/nimbix/notebook-common/master/install-ubuntu.sh /tmp/install-ubuntu.sh
RUN bash /tmp/install-ubuntu.sh && rm -f /tmp/install-ubuntu.sh

COPY NAE/help.html /etc/NAE/help.html

COPY NAE/AppDef.json /etc/NAE/AppDef.json
COPY NAE/screenshot.png /etc/NAE/screenshot.png
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

COPY samples/h2o_deepwater_multi_gpu_mlp.ipynb /usr/local/samples/h2o_deepwater_multi_gpu_mlp.ipynb
COPY scripts/sample_notebook.sh /usr/local/scripts/sample_notebook.sh

# install supervisor and configurations
RUN apt-get install -y supervisor
ADD conf.d/* /etc/supervisor/conf.d/
ADD scripts/rc.local /etc/rc.local

#add Jupyter
RUN pip install --upgrade pip
RUN pip install notebook pyyaml
RUN pip install jupyter
RUN pip install ijson
RUN pip install pandas
RUN pip install python-resize-image

RUN pip install pandas_datareader
RUN pip install httplib2
RUN apt-get install -y build-essential
RUN apt-get install -y libssl-dev
RUN apt-get install -y libffi-dev
RUN apt-get install -y python-dev
RUN apt-get install -y python-matplotlib
RUN apt-get install -y python-lxml
RUN apt-get install -y openssh-server
RUN pip install cython
RUN apt-get install -y python-scipy
RUN pip install scikit-learn
RUN apt-get install -y libxml2-dev libxmlsec1-dev

# h2o python component 
RUN pip install requests
RUN pip install tabulate
RUN pip install scikit-learn
RUN pip install colorama
RUN pip install future 
RUN pip install http://s3.amazonaws.com/h2o-release/h2o/master/3951/Python/h2o-3.13.0.3951-py2.py3-none-any.whl

# modify h2o.py file
COPY scripts/apply_h2o_patch.sh /usr/local/scripts/apply_h2o_patch.sh
COPY scripts/h2o.py.patch /usr/local/scripts/h2o.py.patch
RUN /usr/local/scripts/apply_h2o_patch.sh
COPY scripts/runh2o /usr/local/scripts/runh2o
COPY scripts/startmapd.sh /usr/local/scripts/startmapd.sh

# install demo notebook requesite
RUN pip install Keras

# mapd requirements
RUN apt-get install -y xorg
RUN apt-get install -y initramfs-tools
RUN apt-get install -y pciutils
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre

# install CUDA
ADD https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el-deb /tmp/cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el.deb
RUN dpkg -i /tmp/cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el.deb
RUN apt-get update
RUN apt-get install cuda -y
