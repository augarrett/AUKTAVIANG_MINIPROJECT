# encoding: utf-8
# copyright: 2018, Auktavian Garrett

control 'integration' do
  impact 0.6
  title 'Stelligent Service'
  desc '
   Checks stelligent serivce for necessary setup to serve static content
  '

  describe os.family do
    it { should eq 'debian' }
  end

  describe os.release do
    it { should eq '16.04' }
  end

  describe package('docker-ce') do
    it { should be_installed }
  end

  describe systemd_service('stelligent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end


  describe docker_container('stelligent') do
    it { should exist }
    it { should be_running }
    its('image') { should eq 'stelligent' }
    its('ports') { should eq '0.0.0.0:80->80/tcp' }
  end
end


control 'aws' do
    impact 0.6
    title 'Audit AWS Resources'
    desc '
      Connect to AWS and audit resources created for stelligent serivce
    '

    # load data from terraform output
    content = inspec.profile.file("terraform.json")
    params = JSON.parse(content)

    INSTANCE_ID = params['instance_id']['value']
    IMAGE_ID = params['ami']['value']
    VPC_ID = params['vpc_id']['value']
    RT_TABLE = params['rt_table']['value']
    SUBNET_ID = params['subnet_id']['value']
    KEY_NAME = params['key_pair_id']['value']

    # Find a VPC by ID
    describe aws_vpc(VPC_ID) do
      it { should exist }
    end

    describe aws_subnet(subnet_id: SUBNET_ID) do
      it { should exist }
      its('cidr_block') { should eq '10.0.1.0/24' }
    end

    describe aws_route_table(RT_TABLE) do
      it { should exist }
    end

    describe aws_ec2_instance(INSTANCE_ID) do
      it { should be_running }
      its('instance_type') { should eq 't2.small' }
      its('image_id') { should eq IMAGE_ID }
      its('key_name') { should eq KEY_NAME }
    end
end