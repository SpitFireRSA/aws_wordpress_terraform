# Luno Technical Assessment

This repository contains the necessary components to deploy a Wordpress website running in a docker container in AWS making use of an EC2 host and a dedicated RDS MySQL database instance.  By design the deployment is fully automated by using Terraform to the AWS eu-west-1 region.

Please follow the instructions below to launch the project successfully.

# Requirements
This project requires you to have the following binaries installed on your operating system:

### Binaries:
* Terraform - https://www.terraform.io/downloads.html
* AWS CLI - https://aws.amazon.com/cli/

### AWS Accounts:
* IAM Account with administrative privilleges.

# Initial Setup

## 1. Clone The Repository

1. Navigate to the URL: https://github.com/SpitFireRSA/aws_wordpress_terraform
2. Click the green **Code** button top-right and select **Download ZIP**
3. Save the file in a directory of your choice, where the user has full permission. 
	* **Recommendation:**  Create a new folder under your Documents and name it **aws_wordpress_terraform**
4. Once downloaded, navigate to the folder and extract the zip file contents to the same directory.
	* Deleting the zip file is optional once extracted.

## 2. AWS Profile Configuration

By default this project will use the ***default*** AWS profile configured for the user executing the terraform project.  Do proceed to Section **Launch Project** if the default profile has been configured and is accepted for use.

If you do not have a AWS profile configured, or would like to use a specific profile, then continue to **1. AWS Profile Configuration**.

If you already have a defined AWS profile you would like to use, please continue to **2.3.3**.

### 2.1 Generate AWS Access Keys

1. Navigate to the AWS management console and login with your AWS IAM credentials:
	* https://eu-west-1.console.aws.amazon.com/console/home?region=eu-west-1
2. Once logged in,  search for the **IAM** service in the top-middle search bar and select the **IAM** service option.
3. From the **IAM dashboard**, select the **Users** option from the left hand pane.
4. Select the user that you would like to use for creating the AWS resources from the **User name** field.
5. Select the **Security credentials** tab and click on **Create access key**.
6. Copy the **Access key ID** and the **Secret access key** and paste them in a text editor of your choice. 

	> **Note:** You have to click on the "Show button" before copying the Secret access key.

### 2.2 Configure the AWS profile

1. Open a terminal on your machine.
2. Run the following command to configure your new AWS profile:
	
	***aws configure --profile aws_wordpress_terraform***
3. Paste the **Access key ID** obtained in Step 2.1.6 into the **AWS Access Key ID [None]:** request and press enter.
4. Paste the **Secret access key** obtained in Step 2.1.6 into the **AWS Secret Access Key [None]:** request and press enter.
5. Type **eu-west-1** into the **Default region name [None]:** request and press enter.
6. Type **json** into the **Default output format [None]:** request and press enter.
7. Confirm your new AWS profile has been created by running the following command:

	***aws configure list-profiles***
	
	> **Note:** Confirmation success if the profile name is listed in the output of this command.

### 2.3 Profile Selection

1. Using your favourite IDE or text editor.  Open the file named **main.tf**  that is in the project directory created in Section **1. Clone The Repository** Step 1.4.
2. Update the value in quotes for **region = "eu-west-1"**.
3. Update the value in quotes for **profile = "default"** to **"aws_wordpress_terraform"**

	> **Note:** Specify your desired profile name here if other than **aws_wordpress_terraform**
4. Save the file.


# Launch Project

## 1. Terraform Initiation
1. From the terminal, navigate to the project directory created in Section **1. Clone The Repository** Step 1.4.
2. Run the following command to initialise Terraform:

	***terraform init***
3. The required modules and plugins for the Terraform project will now be downloaded.
4. Once the **Terraform has been successfully initialized!** has can be found in the output, you can proceed to Step 2.1

## 2. Configuration Checks
1. From the terminal, navigate to the project directory created in Section **1. Clone The Repository** Step 1.4.
2. Run the following command to plan and verify the Terraform project configuration:

	***terraform plan***
3. Terraform will iterate through the configuration and verify that all is okay.  Output of the configuration will be produced. 
4. Once completed and successful, you will see the following at the end of the output:

	> Plan: 16 to add, 0 to change, 0 to destroy.
	>
	> Changes to Outputs:
	> \+ lun_ec2_endpoint = (known after apply)

## 3. Launch Terraform

>**Note:** Only proceed if **2. Configuration Checks** was successful.
1. From the terminal, navigate to the project directory created in Section **1. Clone The Repository** Step 1.4.
2. Run the following command to apply and launch the Terraform project:

	***terraform apply***

	> **Note: Run with ***-auto-approve*** to skip step 3&4.

3. Terraform will process the configuration and request if you would like to proceed, with the following question: **Do you want to perform these actions?**
4. Type **yes** and press enter to continue. Terraform will proceed to create the resources in AWS and produce output as it proceeds to do so.  
	> **Note:** This may take a while, please be patient while it's completes.
5. Once completed and successful, you will see the following at the end of the output:
	> Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
	>
	>Outputs:
	>
	> lun_ec2_endpoint = "ec2-xxx-xxx-xxx.compute.amazonaws.com".

	>**Note:** The endpoint in quotes is dynamic and subject to change with every apply.

# Access the Wordpress Website

1. Once the Terraform launch is successful in Section **Launch Project** step 3.4-5, continue to copy the lun_ec2_endpoint defined in quotes.

	>**Example:**     *ec2-13-244-114-136.af-south-1.compute.amazonaws.com*
2. Open your favourite browser and open a new tab. 
3. Paste the copied FQDN in Step 1 into the address bar and press enter.
4. Once completed and successful, you will be directed to the newly created web page.


# Tear Down

Once the project has been successfully deployed, checked, and is no longer required, continue to tear down the resources that was created by Terraform in Section **Launch Project** step 3.4-5.

1. From the terminal, navigate to the project directory created in Section **1. Clone The Repository** Step 1.4.
2. Run the following command to tear down all the resources created by Terraform:

	***terraform destroy***
3. Terraform will continue to destroy all the resources in AWS and produce output as it proceeds to do so. 

	> **Note:** This may take a while, please be patient while it's completes.
4. Once completed and successful, you will see the following at the end of the output:

	>Destroy complete! Resources: 16 destroyed.
5. Finally, delete the SSH key from your local machine by running the following command:

	***rm \*.pem***