terraform-aws-secure-account
============================

Terraform modules for securing AWS accounts

[![Lint and scan](https://github.com/dceoy/terraform-aws-secure-account/actions/workflows/lint-and-scan.yml/badge.svg)](https://github.com/dceoy/terraform-aws-secure-account/actions/workflows/lint-and-scan.yml)

Installation
------------

1.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/terraform-aws-secure-account.git
    $ cd terraform-aws-secure-account
    ````

2.  Install [AWS CLI](https://aws.amazon.com/cli/) and set `~/.aws/config` and `~/.aws/credentials`.

3.  Create a S3 bucket and a DynamoDB table for Terraform.

    ```sh
    $ aws cloudformation create-stack \
        --stack-name s3-and-dynamodb-for-terraform \
        --template-body file://s3-and-dynamodb-for-terraform.cfn.yml
    ```

4.  Create configuration files.

    ```sh
    $ cp envs/com/example.tfbackend envs/com/aws.tfbackend
    $ vi envs/com/aws.tfbackend     # => edit
    $ cp envs/com/example.tfvars envs/com/com.tfvars
    $ vi envs/com/com.tfvars        # => edit
    ```

5.  Initialize a new Terraform working directory.

    ```sh
    $ terraform -chdir='envs/com/' init -reconfigure -backend-config='./aws.tfbackend'
    ```

6.  Generates a speculative execution plan. (Optional)

    ```sh
    $ terraform -chdir='envs/com/' plan -var-file='./com.tfvars'
    ```

7.  Creates or updates infrastructure.

    ```sh
    $ terraform -chdir='envs/com/' apply -var-file='./com.tfvars' -auto-approve
    ```
