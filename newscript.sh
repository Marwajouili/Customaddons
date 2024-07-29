pipeline {
    agent any

    environment {
        REPO_URL = 'git@github.com:Marwajouili/Customaddons.git'
        CUSTOM_ADDONS_PATH = '/opt/odoo/custom_addons'
        ODOO_CONTAINER_NAME = 'odoo'
        REMOTE_IP = '192.168.0.18'
        REMOTE_USER = 'vagrant'
        SSH_CREDENTIALS_ID = 'docker_vm_ssh'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${env.REPO_URL}"
            }
        }

        stage('Copy to Custom Addons on Remote') {
            steps {
                script {
                    // Archive the repository contents
                    sh 'tar -czf repo.tar.gz *'
                    
                    // Copy the tar file to the remote machine
                    sshagent([env.SSH_CREDENTIALS_ID]) {
                        sh """
                        scp -o StrictHostKeyChecking=no repo.tar.gz ${REMOTE_USER}@${REMOTE_IP}:/tmp/
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_IP} 'docker cp /tmp/repo.tar.gz ${ODOO_CONTAINER_NAME}:${CUSTOM_ADDONS_PATH} && docker exec ${ODOO_CONTAINER_NAME} tar -xzf ${CUSTOM_ADDONS_PATH}/repo.tar.gz -C ${CUSTOM_ADDONS_PATH}'
                        """
                    }
                }
            }
        }

        stage('Restart Odoo on Remote') {
            steps {
                script {
                    sshagent([env.SSH_CREDENTIALS_ID]) {
                        sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_IP} 'docker restart ${ODOO_CONTAINER_NAME}'"
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
