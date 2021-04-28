# Terraform script to install n8n on AWS EC2

This is a quick, repeatable terraform to create an EC2 instance on AWS with docker, secured to be only accessible by you. There are a few simple steps to get this running. The process assumes you have an AWS account.

1. Clone the repo to a local directory on your machine
2. Go to the root of that directory
3. Create a new ssh key called n8n. If you want it to be called something else, you need to update the key name in the variables.tf file. The command on a mac is `ssh-keygen -f n8n -N ""`
4. Create a new elastic ip address to use. Make a not of the eip allocation id.
5. Edit the variables.tf file:
   - KEYNAME is the name of your ssh key
   - REGION is the region you want to install this to
   - AZ is the availability zone you want to use
   - IPADDRESS is the address you got for the elastic ip
   - ELASTICIPALLOC is the allocation id for the elastic ip
   - DOCKERCOMPOSEFILE is the name of the docker compose file to use. When you first set this up, using the staging file. After you see things working, switch over to `n8n.docker-compose.yaml`. LetsEncrypt has rate limiting and you easily get to a point where they lock you out for a week. 
   - DOMAIN is your domain name
   - SUBDOMAIN to your subdomain
   - BASICAUTHUSER is the username you want to use for basic auth
   - BASICAUTHPASSWORD is the password you want to use for basic auth
   - EMAIL is the email address you want to associate with your SSL certificate.
   *note* if you prefer, you can specify all of these as environment variables. If you go this route, then preface each of them with TF_VAR_. So DOMAIN would be TF_VAR_DOMAIN. 
6. Run `terraform init` to initialize terraform
7. Run `terraform apply` to deploy the application
8. If everything worked you will get an ssh command at the end to log you in. Run that. 
9.  Look for a `provisioncomplete` file in the ec2-user home directory. That says everything is ready to go.
10. Run `docker-compose up -d` to start n8n.
11. Hopefully it worked.