terraform {
    source ="../../../infrastructure_module/ec2instance"
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
    ami_id        = "ami-06b72b3b2a773be2b"
    env           = include.env.locals.env
    instance_type = "t2.micro"
    subnet_id     = dependency.vpc.outputs.public_subnet_id
    vpc_id        = dependency.vpc.outputs.vpc_id
}

dependency "vpc" {
    config_path = "../vpc"
    
    mock_outputs = {
        public_subnet_id   = "subnet-0123"
        private_subnet_ids = ["subnet-1234", "subnet-5678"]
        vpc_id = "vpc-1234"
    }
}
