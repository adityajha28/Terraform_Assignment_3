terraform {
    source = "../../../infrastructure_module/vpc"
}

include "root" {
    path = find_in_parent_folders()
}

include "env" {
    path           = find_in_parent_folders("env.hcl")
    expose         = true
    merge_strategy = "no_merge"
}

inputs = {
    env             = include.env.locals.env
    azs             = ["ap-south-1a", "ap-south-1b"]
    private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
    public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]
    vpc_cidr_block  = "10.0.0.0/16"

    private_subnet_tags = {
        description = "This is a private subnet"
    }

    public_subnet_tags = {
        description = "This is a public subnet"
    }
}