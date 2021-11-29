init:
	@cd terraform && \
	terraform init

plan:
	@cd terraform && \
	terraform plan

apply:
	@cd terraform && \
	terraform apply

destroy:
	@cd terraform && \
	terraform destroy

val:
	@cd terraform && \
	terraform validate

fmt:
	@cd terraform && \
	terraform fmt -recursive

c:
	@cd terraform && \
	terraform console

update:
	@docker run -it --rm -v $$(pwd)/terraform:/root/terraform minamijoyo/tfupdate terraform -r /root/terraform
	@docker run -it --rm -v $$(pwd)/terraform:/root/terraform minamijoyo/tfupdate provider aws -r /root/terraform
