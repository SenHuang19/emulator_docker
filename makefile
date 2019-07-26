TESTCASE=buildingcontrolemulator
IMG_NAME=buildingcontrolemulator

COMMAND_RUN=docker run \
	  --name ${IMG_NAME} \
	  --rm \
	  -v `pwd`:/usr/testcases \
 	  -it \
	  -p 127.0.0.1:4000:5000

build:
	docker build --build-arg testcase=${TESTCASE} --no-cache --rm -t ${IMG_NAME} .

remove-image:
	docker rmi ${IMG_NAME}

run:
	$(COMMAND_RUN) --detach=false ${IMG_NAME} /bin/bash -c "python /usr/testcases/restapi.py && bash"

run-detached:
	$(COMMAND_RUN) --detach=true ${IMG_NAME} /bin/bash -c "python restapi.py && bash" \
	&& sleep 3

stop:
	docker stop ${IMG_NAME}