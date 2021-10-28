GIT_SHA=$(shell git rev-parse --short HEAD)
USER=nashvan
RELEASE_TAG=1.0.0
HELM_REPO=https://nashvan.github.io/jenkins-helm-chart/
RELEASE_NAME=dev

build:
	@echo Building container
	docker build --build-arg=GIT_SHA=$(git rev-parse --short HEAD) -t jenkins .

push:
	docker tag $(USER)/jenkins:latest $(CI_USER)/jenkins-master:$(RELEASE_TAG) 
	docker push $(USER)/jenkins-master:$(RELEASE_TAG)

plan:
	@echo plan Helm chart 
	helm install --dry-run $(RELEASE_NAME) ./helm/jenkins-k8s

deploy:
	@echo Installing Helm chart 
	helm install $(RELEASE_NAME) ./helm/jenkins-k8s

replan:
	@echo plan Helm chart 
	helm upgrade --dry-run dev ./helm/jenkins-k8s

update:
	@echo Installing Helm chart 
	helm upgrade $(RELEASE_NAME) ./helm/jenkins-k8s

list:
	@echo list deployed Helm charts
	helm list

delete:
	@echo Uninstalling Helm chart 
	helm uninstall $(RELEASE_NAME)

kg:
	@echo display kubernetes resources deployed with Helm chart 
	kubectl get svc,deploy,secret,pvc

kd:
	@echo describe pod details 
	kubectl describe po

run:
	@echo get minikube service url
	minikube service dev-jenkins-k8s --url
