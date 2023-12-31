pipeline 
{
    agent any
    environment {
        TF_VAR_aws_access_key = credentials('aws_access_key')
        TF_VAR_aws_secret_key = credentials('aws_secret_key')
        TF_VAR_project="${Project}"
        TF_VAR_AWS_Region="${AWS_Region}"
        TF_VAR_VPC_CIDR="${VPC_CIDR}"
        TF_VAR_Public_Subnet_CIDR="${Public_Subnet_CIDR}"
        TF_VAR_Private_Subnet_CIDR="${Private_Subnet_CIDR}"
        TF_VAR_AMI_Type="${AMI_Type}"
        TF_VAR_Disk_Size="${Disk_Size}"
        TF_VAR_Capacity_Type="${Capacity_Type}"
        TF_VAR_Worker_Node_Count="${Worker_Node_Count}"
        TF_VAR_Max_Node_Count="${Max_Node_Count}"
        TF_VAR_Min_Node_Count="${Min_Node_Count}"
        TF_VAR_action="${action}"
    }

     parameters {
        string(name: 'Project', defaultValue: 'Test', description: 'Name of terraform project')
        string(name: 'AWS_Region', defaultValue: 'us-east-1', description: 'AWS region where VPC will be present')
        string(name: 'VPC_CIDR', defaultValue: '10.0.0.0/16', description: 'AWS VPC CIDR')
        string(name: 'Public_Subnet_CIDR', defaultValue: '10.0.1.0/24', description: 'AWS public subnet CIDR')
        string(name: 'Private_Subnet_CIDR', defaultValue: '10.0.2.0/24', description: 'AWS private subnet CIDR')
        string(name: 'AMI_Type', defaultValue: 'AL2_x86_64', description: 'AWS ami type')
        string(name: 'Disk_Size', defaultValue: '20', description: 'EC2 disk size')
        string(name: 'Capacity_Type', defaultValue: 'ON_DEMAND', description: 'Instance Type - On-demand, Spot, Reserved')
        string(name: 'Worker_Node_Count', defaultValue: '2', description: 'Number of Worker Nodes')
        string(name: 'Max_Node_Count', defaultValue: '3', description: 'Maximum Number of worker nodes')
        string(name: 'Min_Node_Count', defaultValue: '1', description: 'Minimum number of worker nodes')
        choice(name: 'action', choices: ['plan','apply','destroy'], description: 'Terraform Action to be performed')
    }
    stages {
        stage("Terraform Setup/init"){
            steps {
                sh '''
                terraform init -reconfigure -backend-config="access_key=$TF_VAR_aws_access_key" -backend-config="secret_key=$TF_VAR_aws_secret_key"
                '''
            }
        }
        stage("Terraform dry-run"){
            steps{                  
                sh '''
                echo "Project Name --> "$TF_VAR_project
                echo "AWS Region --> "$TF_VAR_AWS_Region
                echo "AWS VPC CIDR --> "$TF_VAR_VPC_CIDR
                echo "Public Subnet CIDR --> "$TF_VAR_Public_Subnet_CIDR
                echo "Private Subnet CIDR --> "$TF_VAR_Private_Subnet_CIDR
                echo "AWS AMI Type --> "$TF_VAR_AMI_Type
                echo "EC2 Disk Size --> "$TF_VAR_Disk_Size
                echo "Instance Type --> "$TF_VAR_Capacity_Type
                echo "Worker Node Count --> "$TF_VAR_Worker_Node_Count
                echo "Maximum worker node count --> "$TF_VAR_Max_Node_Count
                echo "Minimum worker node count --> "$TF_VAR_Min_Node_Count
                echo "Action --> "$TF_VAR_action
                terraform plan -var="aws_access_key=$TF_VAR_aws_access_key" -var="aws_secret_key=$TF_VAR_aws_secret_key"
                 '''
            }
        }
        stage("Terraform Action"){
            steps{
                sh '''
                if [ $action = "plan" ]; then
                    terraform plan -var="aws_access_key=$TF_VAR_aws_access_key" -var="aws_secret_key=$TF_VAR_aws_secret_key"
                else
                    terraform ${action} --auto-approve -var="aws_access_key=$TF_VAR_aws_access_key" -var="aws_secret_key=$TF_VAR_aws_secret_key"
                fi
                '''
            }
        }
    }
}