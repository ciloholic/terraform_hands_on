init:
	@cd src && \
	terraform init

plan:
	@cd src && \
	terraform plan

apply:
	@cd src && \
	terraform apply

destroy:
	@cd src && \
	terraform destroy

val:
	@cd src && \
	terraform validate

fmt:
	@cd src && \
	terraform fmt -recursive

c:
	@cd src && \
	terraform console

tfupdate:
	docker run -it --rm -v $$(pwd)/src:/root/src minamijoyo/tfupdate terraform -r /root/src
	docker run -it --rm -v $$(pwd)/src:/root/src minamijoyo/tfupdate provider aws -r /root/src
