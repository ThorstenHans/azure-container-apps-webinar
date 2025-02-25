param location string = resourceGroup().location
param name string = 'custom-probes'

param containerImage string = 'thorstenhans/aca-healthprobes:0.0.1'
param containerPort int = 80

module law 'log-analytics.bicep' = {
	name: 'log-analytics-workspace'
	params: {
      location: location
      name: 'law-${name}'
	}
}

module containerAppEnvironment 'aca-environment.bicep' = {
  name: 'aca-env-${name}'
  params: {
    name: 'env-${name}'
    location: location
    lawClientId:law.outputs.clientId
    lawClientSecret: law.outputs.clientSecret
  }
}

module containerApp 'aca.bicep' = {
  name: 'api'
  params: {
    name: 'api'
    location: location
    containerAppEnvironmentId: containerAppEnvironment.outputs.id
    containerImage: containerImage
    containerPort: containerPort
    useExternalIngress: true
  }
}

output fqdn string = containerApp.outputs.fqdn
