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
