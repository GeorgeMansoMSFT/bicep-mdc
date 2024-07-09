param subscriptionId string = '<subscriptionId>'
param workspaceResourceId string = '<la-resourceId>'
param location string = resourceGroup().location

targetScope = 'resourceGroup'

resource continuousExportToLogAnalytics 'Microsoft.Security/automations@2023-12-01-preview' = {
  name: 'ExportToWorkspace'
  location: location
  properties: {
    isEnabled: true
    scopes: [
      {
        description: 'scope for subscription ${subscriptionId}'
        scopePath: '/subscriptions/${subscriptionId}'
      }
    ]
    sources: [
      {
        eventSource: 'Assessments'
        ruleSets: [
          {
            rules: [
              {
                propertyJPath: 'type'
                propertyType: 'String'
                expectedValue: 'Microsoft.Security/assessments'
                operator: 'Contains'
              }
            ]
          }
      ]
      }
      {
        eventSource: 'AssessmentsSnapshot'
        ruleSets: [
          {
            rules: [
              {
                propertyJPath: 'type'
                propertyType: 'String'
                expectedValue: 'Microsoft.Security/assessments'
                operator: 'Contains'
              }
            ]
          }
        ]
      }
      {
        eventSource: 'SubAssessments'
      }
      {
        eventSource: 'SubAssessmentsSnapshot'
      }
      {
        eventSource: 'Alerts'
        ruleSets: [
          {
            rules: [
              {
                propertyJPath: 'Severity'
                propertyType: 'String'
                expectedValue: 'low'
                operator: 'Equals'
              }
              {
                propertyJPath: 'Severity'
                propertyType: 'String'
                expectedValue: 'medium'
                operator: 'Equals'
              }
              {
                propertyJPath: 'Severity'
                propertyType: 'String'
                expectedValue: 'high'
                operator: 'Equals'
              }
              {
                propertyJPath: 'Severity'
                propertyType: 'String'
                expectedValue: 'informational'
                operator: 'Equals'
              }
            ]
          }
        ]
      }
      {
        eventSource: 'AttackPathsSnapshot'
        ruleSets: [
          {
            rules: [
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'Low'
                operator: 'Equals'
              }
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'Medium'
                operator: 'Equals'
              }
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'High'
                operator: 'Equals'
              }
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'Critical'
                operator: 'Equals'
              }
            ]
          }
        ]
      }
      {
        eventSource: 'AttackPaths'
        ruleSets: [
          {
            rules: [
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'Low'
                operator: 'Equals'
              }
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'Medium'
                operator: 'Equals'
              }
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'High'
                operator: 'Equals'
              }
              {
                propertyJPath: 'attackPath.riskLevel'
                propertyType: 'String'
                expectedValue: 'Critical'
                operator: 'Equals'
              }
            ]
          }
        ]
      }
      { 
        eventSource: 'SecureScores'
      }
      {
        eventSource: 'SecureScoresSnapshot'
      }
      {
        eventSource: 'SecureScoreControls'
      }
      {
        eventSource: 'SecureScoreControlsSnapshot'
      }
    ]
    actions: [
        {
          actionType: 'Workspace'
          workspaceResourceId: workspaceResourceId
        }
      ]
  }
}
