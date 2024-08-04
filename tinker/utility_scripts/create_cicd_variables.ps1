# User token and project id
$GITLAB_API_TOKEN="$env:gitlab_token"
$PROJECT_ID="$env:project_id"

# Gitlab endpoints
$GITLAB_BASE_URI = 'https://gitlab.com'
$GITLAB_BASE_API = "$GITLAB_BASE_URI/api/v4"

# Target API for Project-level CI/CD variables
$GITLAB_URI="$GITLAB_BASE_API/projects/$PROJECT_ID/variables"

# Headers
$Headers = @{
    "Authorization" = "Bearer $GITLAB_API_TOKEN"
}

# Key-value pairs should be customized here to your needs
$VariableForm = @(
    @{
        "variable_type" = "env_var"
        "key" = "sample_key1"
        "value" = "dummy"
        "protected" = $false
        "masked" = $false
        "raw" = $true
        "environment_scope" = "*"
        "description" = "Sample key 1 created"
    },
    @{
        "variable_type" = "env_var"
        "key" = "sample_key2"
        "value" = "dummydummy"
        "protected" = $false
        "masked" = $false
        "raw" = $true
        "environment_scope" = "*"
        "description" = "Sample key 2 created"
    }
)


# ====== Helper Function

function CreateVariablesForProject([string] $gitlab_url, [hashtable] $headers, [object[]] $form) {

    $form | ForEach-Object {
        $current_form = $_
        $Result = Invoke-WebRequest -Uri $gitlab_url -Method Post -Headers $headers -Form $current_form
        Write-Output $Result
    }

}


# ==== Actual Execution
Write-Output "[info] Create CI/CD variables for Target Project"
CreateVariablesForProject $GITLAB_URI $Headers $VariableForm
