resource "aws_iam_role" "master-node-role" {
  name = "${var.Project}-master-node-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master-node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.master-node-role.name
}

resource "aws_eks_cluster" "eks-control-plane" {
  name     = "${var.Project}-dev-eks"
  role_arn = aws_iam_role.master-node-role.arn
  vpc_config {
    subnet_ids = [aws_subnet.public-subnet.id, aws_subnet.private-subnet.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
  ]
}

resource "aws_security_group" "master-node-sg" {
  name        = "master-node-sg"
  description = "Cluster communication with worker nodes and internet"
  vpc_id      = aws_vpc.project_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.Project}-master-node-sg"
  }
}

resource "aws_security_group_rule" "cluster-inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.master-node-sg.id
  source_security_group_id = aws_security_group.worker-node-sg.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker-node-sg.id
  source_security_group_id = aws_security_group.master-node-sg.id
  type                     = "egress"
}

/*

EKS Cluster
1. Create role which can access master node
2. Add security group for master node
3. Add inbound rule through which worker node can interact
4. Add outboud rule for internet

*/
