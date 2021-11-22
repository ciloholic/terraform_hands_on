init:
	@cd tf && \
	terraform init

plan:
	@cd tf && \
	terraform plan

apply:
	@cd tf && \
	terraform apply

destroy:
	@cd tf && \
	terraform destroy

val:
	@cd tf && \
	terraform validate

fmt:
	@cd tf && \
	terraform fmt -recursive

c:
	@cd tf && \
	terraform console

update:
	@docker run -it --rm -v $$(pwd)/src:/root/src minamijoyo/tfupdate terraform -r /root/src
	@docker run -it --rm -v $$(pwd)/src:/root/src minamijoyo/tfupdate provider aws -r /root/src
