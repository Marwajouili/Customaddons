pipeline {
    agent any
    environment {
        GIT_SSH_COMMAND = 'ssh -i /var/lib/jenkins/.ssh/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'git@github.com:Marwajouili/Customaddons.git'
            }
        }
        stage('Run Script') {
            steps {
                sh 'chmod +x newscript.sh'
                sh './newscript.sh'
            }
        }
    }
}
