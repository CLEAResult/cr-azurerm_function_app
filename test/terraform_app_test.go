package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformServer(t *testing.T) {
	t.Parallel()

	targetedTfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./fixture",
	}

	// This will init and apply the targeted resources and fail
	// the test if there are any errors
	terraform.InitAndApply(t, targetedTfOptions)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./fixture",
	}

	// This will apply the resources and fail the test if there
	// are any errors
	terraform.Apply(t, terraformOptions)

	// At the end of the test, clean up any resources that were created
	terraform.Destroy(t, terraformOptions)
}
