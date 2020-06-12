# 1. Instalar dependencias
FROM python

RUN apt-get update

RUN yes | apt install mpich
RUN yes | pip3 install mpi4py

ADD example.py /mpi/example.py
RUN apt-get install -y openssh-server

# 2. Configurar sshd
RUN mkdir /var/run/sshd

RUN echo 'root:SergioEsElMejorProfeDelTec' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
WORKDIR /mpi

RUN mkdir -p /root/.ssh/
ADD mpi_cluster.pub mpi_cluster.pub
ADD mpi_cluster mpi_cluster
# 3. Agregar las claves privada /publica de ssh
RUN cat mpi_cluster.pub >> /root/.ssh/authorized_keys
RUN cp mpi_cluster /root/.ssh/id_rsa
RUN cp mpi_cluster.pub /root/.ssh/id_rsa.pub

RUN chmod 600 /root/.ssh/id_rsa

COPY ssh_config /etc/ssh/ssh_config

EXPOSE 22
RUN service ssh restart
CMD ["/usr/sbin/sshd", "-D"]

RUN pip3 install numpy
RUN pip3 install opencv-python
RUN pip3 install google-cloud-firestore
RUN pip3 install google-cloud-storage
RUN pip install -U textblob