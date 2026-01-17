resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = var.db_name
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.db_name}-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # adjust if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = var.db_name
  engine             = var.engine
  engine_version     = var.engine_version

  database_name   = var.db_name
  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true

  tags = {
    Name        = var.db_name
    Environment = var.environment
  }
}

resource "aws_rds_cluster_instance" "this" {
  count              = 1
  identifier         = "${var.db_name}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.t3.medium"
  engine             = var.engine
  engine_version     = var.engine_version
}
