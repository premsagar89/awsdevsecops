/* AWS IMAGE TYPE LAMBDA */
resource "aws_lambda_function" "lambda" {
  function_name = "${var.lambdaFuncName}"
  role          = "${var.roleARN}"
  image_uri     = "${var.lambdaImageUri}"
  package_type  = "${var.packageType}"

  /* handler       = "${var.lambdaHandler}" // Should Not Use if Function Packaged types is IMAGE */
  /* runtime       = "${var.lambdaRuntime}" // Should Not Use if Function Packaged types is IMAGE */
  /* filename      = "../sourcecode/lambda_function.py" */
   
  ephemeral_storage {
    size = "${var.ephemeralStorage}"
  }
}