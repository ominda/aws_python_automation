# Take out the public subnets
output "o_public_subnets" {
    value = {
        public_subnet-01 = "${aws_subnet.r_public_subnets[0].id}",
        public_subnet-02 = "${aws_subnet.r_public_subnets[1].id}"
    }
}

# output "o_private_subnets" {
#   value = aws_subnet.r_private_subnets
# }

output "o_vpc" {
  value = aws_vpc.r_vpc  
}