---
title: "Importing existing cloud resources to TF through gcloud"
date: 2025-06-10
author: ["josiah"]
draft: false
tags: ["til", "terraform"]
---

Lets say you inherit some Very Terrible Infrastructure. There's 10s of cloud accounts (sorry I mean subscriptions (sorry I mean projects)) with infrastructure and applications manually deployed Fucking Everywhere. You, after recovering from an initial bout of "i've made a huge mistake" vomitting, start trying to bring all this shit under version control. Manually importing existing resources in Terraform still sucks, so you look into some better options. You eventually find [Terraformer](https://github.com/GoogleCloudPlatform/terraformer). This is a Good Tool, and i've used it in the past. As of the time of writing there's a breaking compat change somewhere between what Terrformer expects and the `gcp compute instance` provider used; you can't import existing GCP compute instances. You get funny errors like:


```bash
2025/06/05 12:39:37 google importing project my-project region global
2025-06-05T12:39:37.568-0500 [ERROR] plugin.terraform-provider-google_v6.38.0_x5: Response contains error diagnostic: @module=sdk.proto diagnostic_attribute="" diagnostic_severity=ERROR diagnostic_summary="Value Conversion Error" tf_proto_version=5.8 tf_provider_addr=registry.terraform.io/hashicorp/google tf_req_id=882f217f-5b22-0694-f7e4-5d85387a589f @caller=github.com/hashicorp/terraform-plugin-go@v0.26.0/tfprotov5/internal/diag/diagnostics.go:58
  diagnostic_detail=
  | An unexpected error was encountered trying to build a value. This is always an error in the provider. Please report the following to the provider developer:
  |
  | Received null value, however the target type cannot handle null values. Use the corresponding `types` package type, a pointer type or a custom type that handles null values.
  |
  | Path:
  | Target Type: fwmodels.ProviderModel
  | Suggested `types` Type: basetypes.ObjectValue
  | Suggested Pointer Type: *fwmodels.ProviderModel
   tf_rpc=Configure timestamp=2025-06-05T12:39:37.568-0500
2025/06/05 12:39:37 google importing... instances
2025/06/05 12:39:37 google done importing instances
2025/06/05 12:39:37 Number of resources for service instances: 0
2025/06/05 12:39:37 google Connecting....
2025/06/05 12:39:37 google save instances
2025/06/05 12:39:37 google save tfstate for instances
```

This error *continues* which is also very stupid.

Don't give up hope - Google doesn't appear to care about this tool but DOES care about `gcloud` and has a `beta` command (lol, lmao) that can ~replace terraformer usage for GCP resources. Doc page [here](https://cloud.google.com/docs/terraform/resource-management/export):

And the salient command:
```bash
gcloud beta resource-config bulk-export \
  --project=PROJECT_ID \
  --resource-format=terraform
```

This is really nice! I wonder how long before google stops supporting it.
