# Managing Servers state in AWS

## Creating a managed relational database in AWS

### STORAGE OPTIONS

AWS comes with a wide variety of options for storing your data. These range from SQL based solutions like POSTGRES, MYSQL, Aurora, and even MSSQL to NOSQL based solutions like DynamoDB. 

In this lab we're going to set up and deploy an RDS (Relational Database System) then work on creating Virtual Private clouds for the RDS instance to live in.

Let's start from the management console and typing "RDS" into the SEARCH function. That should bring up a screen that looks like this:

![createdb](./createdb.png)

Click on "Create database" and let's get started.

![choosedb](./choosedb.png)

Let's choose the following:

* MySQL database
* Templates: FREE TIER
* Settings: create a name
* Credentials: Set username and password
* DB Instance Size: Choose smallest (micro)
* Storage: Leave defaults
* Availability: Leave defaults
* Connectivity: Default VPC
* **Public Accessibility MUST be set to "yes"**
* Database Authentication: Password Authentication
* Click on CREATE database

![dbcreating](./dbcreating.png)

Now we wait. It could take a few minutes so grab a cup of joe!
(In the interim let's take a look at my dog from Bulgaria!)

![folorapassport](./florapassport.jpg)

Once everything is created try to connect from your favourite GUI:

Once it's done creating click on the database name. You should see an endpoint.
Using that endpoint , the port (3306) and the connection information go ahead and connect using your favourite GUI. 

![guiconnect](./guiconnect.png)

CONGRATULATIONS!

## Creating a VPC

1. Let's start by creating a new VPC and launching an EC2 instance in it (using the management console):
  
  * Create the VPC via the launch wizard. Give it both a **public** and a **private** subnet...one to face the internet and one to store our data.
  * Allow a NAT Gateway to  be created here.

2. Now go in to **Launch Instance** and create an ec2 instance. Instead of jumping right to **Launch Instance** as the final default though we need to **configure the instance** here to make sure that it launches in the appropriate VPC (the new one that we just created).

![configvpc](./configvpc.png)

3. For **Placement group** let's leave this blank but let's do a quick summary of what this means....basically the **placement group** is your chance to create a cluster of low-latency ec2 instances that can communicate with each other quickly. From the AWS definitions:

*  A cluster placement group is a logical grouping of instances within a single Availability Zone that benefit from low network latency, high network throughput. A spread placement group places instances on distinct hardware.

4. For some of the other options:
 
 ![tenancy](./tenancy.png)

* **Shutdown Behavior** is pretty obvious
* **Enable Termination Protection** is also pretty obvious (will stop accidental termination)
* **Cloudwatch Monitoring** is also obvious- do you want to enable the ability to log and monitor beyond the defaults?
* **Tenancy** is a concept that Salesfoce is probably familiar with: Do you want to reserve physical hardware space within the AWS data center?

5. Keep the single network interface BUT...instead of launching at this point let's select **Add Storage**. **THIS IS WHERE WE ARE GOING TO BE KEEPING OUR ELASTIC BLOCK STORE DATA PERSISTENT**

6. On the next page (Step 4) DESELECT the **Delete On Termination** for the Elastic Block Store (the mounted network drive). This is *how we can keep data persistent beyond the life of the EC2 instance*

![ebsperm](./ebsperm.png)

7. **This will persist the EBS Block Storage beyond when we delete the EC2 instance!!** This is useful for things like retaining logs and/or state.

8. Leave everything else as defaults (including your security groups- we'll come back around to this) 

9. Now let's add an elastic IP address to our EC2 instance! Navigate [here](https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#Addresses:sort=PublicIp) (or choose Elastic IPs from the menu) and associate with your EC2 instance. 

10. *IT'S POSSIBLE* that your elastic IP is associated with your NAT gateway. If so go ahead and delete the nat gateway and try again...

![natgateway](./natgateway.png)

11. Now plug your elastic IP into your browser and see if it worked. Did it? 

## Creating a Load Balancer to go with everything

1. So the first thing to understand about LOAD BALANCERS is that they look at **target groups** not instances!

2. So step one is to go to the EC2 page again and scroll down until we get to the **load balancers** section. This will open up in to a menu that looks like this:

![loadbalancers](./loadbalancers.png)

3. From here all we need to do is create the load balancer. Let's choose the **http/https load balancer** BUT...we're going to go over the  Network Load balancer now....
What's the difference? Basically...one faces the internet and one basically exists to pass data through the network from inside...so if you have an internal object that is sending high flow data you would use the Network Load balancer. If you have an internet facing application you would use http.

4. When you choose to configure load balancer let's put it in our VPC along with our EC2 instance and point it to the instance.Let's add it to the PUBLIC subnet as well...

![loadconfig](./loadconfig.png)

5. Oh SHOOT! Are we short on availability zones? WELL! Where can we go to create new subnets??

6. Let's go over to our VPC and choose "Subnets"-> Create New Subnets. Now let's create a new Subnet with CIDR **10.0.2.0/24**

![subnets.png](./subnets.png)


