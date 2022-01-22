pipeline {
    agent any 
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        }

    stages{
        stage('Create S3 bucket with ansible'){
            steps{
                sh "ansible-playbook s3backend.yml"
            }
        }
        stage('Terraform init and deploy to dev'){
            steps{
                sh label: '', returnStatus: true, script: 'terraform workspace new dev'
                sh "terraform init -reconfigure"
                sh "ansible-playbook terraform.yml"
            }
        }
        stage('Terraform init and deploy to prod'){
            steps{
                sh label: '', returnStatus: true, script: 'terraform workspace new prod'
                sh "terraform init -reconfigure"
                sh "ansible-playbook terraform.yml -e app_env=prod"
            }
        }
    }
}

def getTerraformPath(){
    def tfHome = tool name: 'terraform', type: 'terraform'
    return tfHome
}
