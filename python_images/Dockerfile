FROM python 
# we are using a base image --that image will be pulled from docker hub 
# during custom image build time 
LABEL name=ashutoshh
LABEL email=ashutoshh@linux.com 
# to tag image creator info  optional field 
RUN  mkdir  /codes 
#  to give shell during image build time 
COPY  abc.py  /codes/ 
# copy code inside image 
CMD ["python","/codes/abc.py"]
# for setting default process for this image 
# default process for containers which will be created from this Image 