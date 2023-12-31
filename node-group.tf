resource "aws_iam_role" "worker-node-role" {
  name = "${var.project}-worker-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker-node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker-node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker-node-role.name
}

resource "aws_eks_node_group" "eks-dev-worker-node" {
  cluster_name    = aws_eks_cluster.eks-control-plane.name
  node_group_name = "${var.project}-dev-worker-node"
  node_role_arn   = aws_iam_role.worker-node-role.arn
  subnet_ids      = [aws_subnet.public-subnet.id]

  scaling_config {
    desired_size = var.Worker_Node_Count
    max_size     = var.Max_Node_Count
    min_size     = var.Min_Node_Count
  }
  ami_type       = var.AMI_Type
  instance_types = var.EC2_Instance_Type
  capacity_type  = var.Capacity_Type
  disk_size      = var.Disk_Size

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_security_group" "worker-node-sg" {
  name        = "${var.project}-node-sg"
  description = "security group for worker node"
  vpc_id      = aws_vpc.project_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                           = "${var.project}-worker-node-sg"
    "kubernetes.io/cluster/${var.project}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "node-internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker-node-sg.id
  source_security_group_id = aws_security_group.worker-node-sg.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-inbound" {
  description       = "Allow incoming internet traffic"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.worker-node-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "node-cluster-internal" {
  description              = "Allow kubelet and pods to receive communication from the control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker-node-sg.id
  source_security_group_id = aws_security_group.master-node-sg.id
  type                     = "ingress"
}

/*

create role which can access worker node
create worker node
security group for worker node
add inbound rule through which master node can interact

*/
