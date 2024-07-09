param securityEmailAddress string = '<emailaddress>'
param continuousExportResourceGroupName string = '<ce-resourcegroup>'
param sqlLogAnalyticsWorkspaceResourceId string = '<la-resourceId>'
param sqlLogAnalyticsWorkspaceRegion string = 'centralus'
param sqlLogAnalyticsWorkspaceId string = '<la-shortId>'

targetScope = 'subscription'

resource defenderForServers 'Microsoft.Security/pricings@2024-01-01' = {
    name: 'VirtualMachines'
    properties: {
      enforce: 'True'
      extensions: [
        {
          name: 'MdeDesignatedSubscription'
          isEnabled: 'False'
        }
        {
          name: 'AgentlessVmScanning'
          isEnabled: 'True'
          additionalExtensionProperties: {
            ExclusionTags: '[]'
          }
        }
        {
          name: 'FileIntegrityMonitoring'
          isEnabled: 'False'
        }
      ]
      subPlan: 'P2'
      pricingTier: 'Standard'
    }
}

resource defenderForAppService 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'AppServices'
  properties: {
    enforce: 'True'
    pricingTier: 'Standard'
  }
}

resource defenderForSqlServers 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'SqlServers'
  properties: {
    enforce: 'True'
    pricingTier: 'Standard'
  }
}

resource defenderForSqlServerVirtualMachines 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'SqlServerVirtualMachines'
  properties: {
    enforce: 'True'
    pricingTier: 'Standard'
  }
}

resource defenderForOpenSourceRelationalDatabases 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'OpenSourceRelationalDatabases'
  properties: {
    enforce: 'True'
    pricingTier: 'Standard'
  }
}

resource defenderForCosmosDbs 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'CosmosDbs'
  properties: {
    enforce: 'True'
    pricingTier: 'Standard'
  }
}

resource defenderForSqlAddonPolicyDefinition 'Microsoft.Authorization/policySetDefinitions@2021-06-01' existing = {
  name: 'de01d381-bae9-4670-8870-786f89f49e26'
  scope: tenant()
}

resource defenderForSqlAddonPolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Defender for SQL on SQL VMs and Arc-enabled SQL Servers- Custom'
  #disable-next-line no-loc-expr-outside-params
  location: deployment().location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    defenderForSqlServers
  ]
  properties: {
    description: 'This policy assignment was automatically created by Microsoft Defender for Cloud for agent installation as configured in Defender for Cloud auto provisioning.'
    displayName: 'Defender for SQL on SQL VMs and Arc-enabled SQL Servers- Custom'
    enforcementMode: 'Default'
    policyDefinitionId: defenderForSqlAddonPolicyDefinition.id
    parameters: {
      userWorkspaceId: {
        value: sqlLogAnalyticsWorkspaceId
      }
      workspaceRegion: {
        value: sqlLogAnalyticsWorkspaceRegion
      }
      userWorkspaceResourceId: {
        value: sqlLogAnalyticsWorkspaceResourceId
      }
  }
}
}

resource defenderForStorageAccounts 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'StorageAccounts'
  properties: {
    enforce: 'True'
    pricingTier: 'Standard'
    extensions: [
      {
        name: 'OnUploadMalwareScanning'
        isEnabled: 'False'
      }
      {
        name: 'SensitiveDataDiscovery'
        isEnabled: 'True'
      }
    ]
    subPlan: 'DefenderForStorageV2'
  }
}

resource defenderForKeyVaults 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'KeyVaults'
  properties: {
    enforce: 'True'
    subPlan: 'PerKeyVault'
    pricingTier: 'Standard'
  }
}

resource defenderForContainers 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'Containers'
  properties: {
    enforce: 'True'
    extensions: [
      {
        name: 'ContainerRegistriesVulnerabilityAssessments'
        isEnabled: 'True'
      }
      {
        name: 'AgentlessDiscoveryForKubernetes'
        isEnabled: 'True'
      }
      {
        name: 'ContainerSensor'
        isEnabled: 'True'
      }
    ]
    pricingTier: 'Standard'
  }
}

resource containersAddonPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' existing = {
  name: 'a8eff44f-8c92-45c3-a3fb-9880802d67a7'
  scope: tenant()
}

resource containersAddonPolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Defender for Containers provisioning Azure Policy Addon for Kub'
  #disable-next-line no-loc-expr-outside-params
  location: deployment().location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    containersAddonPolicyDefinition
  ]
  properties: {
    description: 'This policy assignment was automatically created by Azure Security Center for agent installation as configured in Security Center auto provisioning.'
    displayName: 'Defender for Containers provisioning Azure Policy Addon for Kubernetes'
    enforcementMode: 'Default'
    policyDefinitionId: containersAddonPolicyDefinition.id
  }
}

resource containersArcExtensionPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' existing = {
  name: '0adc5395-9169-4b9b-8687-af838d69410a'
  scope: tenant()
}

resource containersArcExtensionPolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Defender for Containers provisioning Policy extension for Arc-e'
  #disable-next-line no-loc-expr-outside-params
  location: deployment().location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    defenderForContainers
  ]
  properties: {
    description: 'This policy assignment was automatically created by Azure Security Center for agent installation as configured in Security Center auto provisioning.'
    displayName: 'Defender for Containers provisioning Policy extension for Arc-enabled Kubernetes'
    enforcementMode: 'Default'
    policyDefinitionId: containersArcExtensionPolicyDefinition.id
  }
}

resource containersProvisioningArcPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' existing = {
  name: '708b60a6-d253-4fe0-9114-4be4c00f012c'
  scope: tenant()
}
 
resource containersProvisioningArcPolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Defender for Containers provisioning ARC k8s Enabled'
  #disable-next-line no-loc-expr-outside-params
  location: deployment().location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    defenderForContainers
  ]
  properties: {
    description: 'This policy assignment was automatically created by Azure Security Center for agent installation as configured in Security Center auto provisioning.'
    displayName: 'Defender for Containers provisioning ARC k8s Enabled'
    enforcementMode: 'Default'
    policyDefinitionId: containersProvisioningArcPolicyDefinition.id
  }
}
 
resource containersSecurityProfilePolicyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' existing = {
  name: '64def556-fbad-4622-930e-72d1d5589bf5'
  scope: tenant()
}
 
resource containersSecurityProfilePolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'Defender for Containers provisioning AKS Security Profile'
  #disable-next-line no-loc-expr-outside-params
  location: deployment().location
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    defenderForContainers
  ]
  properties: {
    description: 'This policy assignment was automatically created by Azure Security Center for agent installation as configured in Security Center auto provisioning.'
    displayName: 'Defender for Containers provisioning AKS Security Profile'
    enforcementMode: 'Default'
    policyDefinitionId: containersSecurityProfilePolicyDefinition.id
  }
}

resource defenderForArm 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'Arm'
  properties: {
    enforce: 'True'
    subPlan: 'PerSubscription'
    pricingTier: 'Standard'
  }
}

resource defenderForApi 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'Api'
  properties: {
    enforce: 'True'
    pricingTier: 'Free'
  }
}

#disable-next-line BCP081
resource defenderVulnerabilityManagement 'Microsoft.Security/serverVulnerabilityAssessmentsSettings@2023-05-01' = {
  name: 'AzureServersSetting'
  kind: 'AzureServersSetting'
  dependsOn: [
    defenderForServers
  ]
  properties: {
    selectedProvider: 'MdeTvm'
  }
}

resource defenderEndpointProtection 'Microsoft.Security/settings@2022-05-01' = {
  name: 'WDATP'
  kind: 'DataExportSettings'
  dependsOn: [
    defenderForServers
  ]
  properties: {
    enabled: true
  }
}

resource securityContacts 'Microsoft.Security/securityContacts@2023-12-01-preview' = {
  name: 'default'
  properties: {
    notificationsSources: [
      {
        sourceType: 'Alert'
        minimalSeverity: 'High'
      }
      {
        sourceType: 'AttackPath'
        minimalRiskLevel: 'High'
      }
    ]
   emails: securityEmailAddress
    notificationsByRole: {
      state: 'On'
      roles: [
        'Owner'
        'AccountAdmin'
      ]
    }
  }
}

resource continuousExportResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: continuousExportResourceGroupName
  location: deployment().location
}
