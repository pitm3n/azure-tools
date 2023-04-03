# Dump all policies to json files

$assignments = Get-AzPolicyAssignment

foreach ($assignment in $assignments) {
    Write-Host "Assignment Name: $($assignment.Name)" -fore Red
    Write-Host "Assignment Id: $($assignment.ResourceId)" -fore Red
    if ($assignment.Properties.PolicyDefinitionId -like "*/policyDefinitions/*") {
        $definition = Get-AzPolicyDefinition -Id $assignment.Properties.PolicyDefinitionId
        Write-Host $definition.Name -fore Blue
        $filename = $definition.Name + ".json"
        $definition | ConvertTo-Json -Depth 20 | Out-File $filename
    }
    else {
        $initiative = Get-AzPolicySetDefinition -Id $assignment.Properties.PolicyDefinitionId
        foreach ($definitionId in $initiative.Properties.PolicyDefinitions.policyDefinitionId) {
            $definition = Get-AzPolicyDefinition -Id $definitionId
            Write-Host $definition.Name -fore Blue
            $filename = $definition.Name + ".json"
            $definition | ConvertTo-Json -Depth 20 | Out-File $filename
        }
    }
}
