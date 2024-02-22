# Prerequisites

Before deploying the infrastructure using Terragrunt, ensure the following prerequisites are met:

1. **Terraform and Terragrunt Installed:**
   - Install [Terraform](https://www.terraform.io/downloads.html).
   - Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install.html).

2. **AWS CLI Configured:**
   - Configure AWS CLI with appropriate access credentials and region.

3. **Infrastructure Module:**
   - Ensure the `infrastructure_module` directory contains the necessary Terraform modules for VPC (`vpc`) and EC2 instance (`ec2instance`).

4. **Customize Configuration:**
   - Review and customize the variables in `infra_2/dev/env.hcl`, `infra_2/staging/env.hcl`, and `infra_2/prod/env.hcl` files based on your specific requirements.
# Terraform with Terragrunt for Multiple Environments

## Project Structure

```plaintext
my_project/
|-- infrastructure_module/
|   |-- vpc/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- vpc.tf
|   |   |-- subnet.tf
|   |   |-- igw.tf
|   |   |-- routetable.tf
|   |   |-- outputs.tf
|   |-- ec2instance/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- securitygroup.tf
|   |   |-- ec2_instance.tf
|   |
|-- infra_2/
|   |-- dev/
|   |   |-- ec2_instance/
|   |   |   |-- terragrunt.hcl
|   |   |-- vpc/
|   |   |   |-- terragrunt.hcl
|   |   |-- env.hcl
|   |-- staging/
|   |   |-- ec2_instance/
|   |   |   |-- terragrunt.hcl
|   |   |-- vpc/
|   |   |   |-- terragrunt.hcl
|   |   |-- env.hcl
|   |-- prod/
|   |   |-- ec2_instance/
|   |   |   |-- terragrunt.hcl
|   |   |-- vpc/
|   |   |   |-- terragrunt.hcl
|   |   |-- env.hcl
|   |-- terragrunt.hcl
```

## `infrastructure_module` Structure

### `vpc` Module

- **main.tf**: Defines the AWS VPC, including its CIDR block, DNS support, and DNS hostnames.

- **variables.tf**: Declares variables used in the `vpc` module, such as environment name, CIDR block, availability zones, and subnet tags.

- **vpc.tf**: Creates the AWS VPC resource using the specified CIDR block and tags.

- **subnet.tf**: Defines private and public subnets within the VPC, associating them with availability zones.

- **igw.tf**: Creates an Internet Gateway and attaches it to the VPC.

- **routetable.tf**: Sets up route tables for private and public subnets, associating the public subnet with the Internet Gateway.

- **outputs.tf**: Exposes VPC and subnet IDs as outputs.

### `ec2instance` Module

- **main.tf**: Specifies the AWS EC2 instance resource, including AMI, instance type, subnet, and user data script.

- **variables.tf**: Declares variables used in the `ec2instance` module, such as environment name, AMI ID, instance type, subnet ID, and VPC ID.

- **securitygroup.tf**: Configures a security group allowing inbound SSH and HTTP traffic.

- **ec2_instance.tf**: Creates an EC2 instance with the specified configuration and associates it with the defined security group.

## `terragrunt.hcl` Files Explanation

### Global `terragrunt.hcl` in `infra_2/`

- **`remote_state` Block:** Specifies the backend configuration for storing Terraform state locally. It generates a backend configuration file (`backend.tf`) during the `terragrunt init` process.

- **`generate "provider"` Block:** Generates a provider configuration file (`provider.tf`) during the `terragrunt init` process, ensuring a consistent AWS provider configuration across all environments.

### `terragrunt.hcl` in Each Environment (e.g., `infra_2/dev/ec2_instance/`)

- **`terraform` Block:** Specifies the source location for the Terraform configuration (in this case, the `infrastructure_module/ec2instance`).

- **`include "root"` Block:** Includes the root Terragrunt configuration (`infra_2/terragrunt.hcl`) to inherit common settings.

- **`include "env"` Block:** Includes the environment-specific settings from `env.hcl` and exposes them for merging.

- **`inputs` Block:** Defines environment-specific variables used in the Terraform module. These variables are filled in from the `env.hcl` file.

- **`dependency "vpc"` Block:** Specifies a dependency on the VPC configuration, allowing the EC2 instance module to reference VPC outputs. It also includes a mock output for testing without the actual VPC.

## `env.hcl` File Explanation

- **`locals` Block:** Defines local variables for the environment. In this case, it sets the `env` variable to a specific environment name (e.g., "dev" for the development environment).

Each environment (dev, staging, prod) has its own `env.hcl` file with a unique value for the `env` variable. This file allows Terragrunt to differentiate between environments and pass the correct environment name to the Terraform module.

The combination of `terragrunt.hcl` and `env.hcl` files allows for modular and environment-specific configurations, making it easy to manage and deploy infrastructure across different environments using Terragrunt.

## Terragrunt Deployment Commands

To initialize Terragrunt in all subdirectories:

```bash
terragrunt run-all init
```

To create execution plans for all Terragrunt configurations:

```bash
terragrunt run-all plan
```

To apply changes for all Terragrunt configurations:

```bash
terragrunt run-all apply
```

To destroy infrastructure for all Terragrunt configurations:

```bash
terragrunt run-all destroy
```

These commands streamline the deployment process across multiple environments, ensuring consistent infrastructure management using Terragrunt. Adjust the commands based on specific deployment needs and environment configurations.
# Deployment Screenshots

## Initialization

### Command

```bash
terragrunt run-all init
```

### Result
- dev
![dev_init](https://github.com/adityajha28/git-assignment/assets/127980079/5dd21f3a-34f4-4588-aa71-53160985ab8d)

- prod
![prod_init](https://github.com/adityajha28/git-assignment/assets/127980079/af5002a5-f237-444f-98f9-4aabeb17e2cd)

- staging
![staging_init](https://github.com/adityajha28/git-assignment/assets/127980079/97aa7c25-02bd-4042-8742-b0d6fc6fd08a)

---

## Plan

### Command

```bash
terragrunt run-all plan
```

### Result
- dev
![dev_plan](https://github.com/adityajha28/git-assignment/assets/127980079/400e1273-8c03-4196-bac4-531cd5172ce2)

- prod
![prod_plan](https://github.com/adityajha28/git-assignment/assets/127980079/ab8d3836-23c2-41b3-b8b0-d24e0bab4c79)

- staging
![staging_plan](https://github.com/adityajha28/git-assignment/assets/127980079/62de523a-8c46-4a75-9b02-fe1878a372c7)


---

## Apply

### Command

```bash
terragrunt run-all apply
```

### Result
- dev
![dev_apply](https://github.com/adityajha28/git-assignment/assets/127980079/138797cc-b244-4f26-8f27-98d857c5f602)
![dev_apply-1](https://github.com/adityajha28/git-assignment/assets/127980079/beb0da55-9235-4ec7-95ec-bd5968bdea52)
![dev_apply2](https://github.com/adityajha28/git-assignment/assets/127980079/c260cf7f-f7df-4202-90d2-83d4212cef3b)

- prod
![prod_apply](https://github.com/adityajha28/git-assignment/assets/127980079/12d2a071-6b89-4746-b8bf-4d850cbc9a8b)
![prod_apply1](https://github.com/adityajha28/git-assignment/assets/127980079/2a928407-4266-4ff9-9f74-70e013d42d28)
![prod_apply2](https://github.com/adityajha28/git-assignment/assets/127980079/19c644b8-0178-4f94-a3a9-11b027f1f43e)

- staging
![staging_apply](https://github.com/adityajha28/git-assignment/assets/127980079/56e47cbc-560c-43bb-a6d1-057af1ad24b1)
![staging_apply-1](https://github.com/adityajha28/git-assignment/assets/127980079/6b3c9f1f-9996-4798-a223-19d215417d8b)
![staging_apply2](https://github.com/adityajha28/git-assignment/assets/127980079/89cbea32-c810-4c4f-a362-a61413fa497f)


---

## AWS Console - VPC

### VPC Created

- dev
![dev_vpc](https://github.com/adityajha28/git-assignment/assets/127980079/9ff6053d-8cd5-43f2-a0bb-337be072d183)

- prod
![prod_vpc](https://github.com/adityajha28/git-assignment/assets/127980079/542e71f6-e649-4c04-a096-4dd3d58d338b)

- staging
![staging_vpc](https://github.com/adityajha28/git-assignment/assets/127980079/974ed60b-60ad-4edd-b27a-c8bdf29445a4)

---


## AWS Console - EC2 Instance

### EC2 Instance Created
- dev
![dev_instance](https://github.com/adityajha28/git-assignment/assets/127980079/932e2a48-f6f5-48fc-859b-61712f67846c)
![dev_inst1](https://github.com/adityajha28/git-assignment/assets/127980079/bb4457e8-486a-41bc-b55b-c53bd5fa20d8)

- prod
![prod_instance](https://github.com/adityajha28/git-assignment/assets/127980079/10c0805b-d4fa-44bb-92d9-19eb81f461c3)

- staging
![staging_instance](https://github.com/adityajha28/git-assignment/assets/127980079/ddebc4f7-af65-4a97-96f3-ac9acc1f10cd)


---

### Result
- Instances and VPCs
![3instances](https://github.com/adityajha28/git-assignment/assets/127980079/f36f6649-f1b1-4ec0-a017-f7952c9a7c46)
![3vpc](https://github.com/adityajha28/git-assignment/assets/127980079/181f670d-3219-4a16-8801-084db27055bf)


**Note:** These screenshots provide a visual representation of the commands and their results during the deployment process. Ensure that you review the AWS Console to verify the creation and deletion of resources.
