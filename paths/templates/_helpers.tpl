{{/*
Expand the name of the chart.
*/}}
{{- define "paths.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paths.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Encode image pull credentials to be stored in the k8s secret we create.
https://helm.sh/docs/howto/charts_tips_and_tricks/#creating-image-pull-secrets
*/}}
{{- define "paths.imagePullSecretData" -}}
{{- with .Values.imagePullSecret }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "paths.imagePullSecretName" -}}
{{- default (printf "%s-docker-registry" (include "paths.fullname" .)) .Values.imagePullSecret.name }}
{{- end }}

{{- define "paths.argoCdImagePullSecretName" -}}
{{- default (printf "%s-docker-registry" (include "paths.fullname" .)) .Values.argoCd.imagePullSecret.name }}
{{- end }}

{{- define "paths.backendDjangoArgoCdApplicationName" -}}
{{- default (printf "%s-backend" (include "paths.fullname" .)) .Values.backend.django.argoCdApplication.name }}
{{- end }}

{{- define "paths.backendAdminRedirectMiddlewareName" -}}
{{- default (printf "%s-backend-redirectregex-admin" (include "paths.fullname" .)) .Values.backend.adminRedirectMiddlewareName }}
{{- end }}

{{- define "paths.backendIngressTlsSecretName" -}}
{{- default (printf "%s-backend-tls" (include "paths.fullname" .)) .Values.backend.django.ingress.tlsSecretName }}
{{- end }}

{{- define "paths.uiNextjsArgoCdApplicationName" -}}
{{- default (printf "%s-ui" (include "paths.fullname" .)) .Values.ui.nextjs.argoCdApplication.name }}
{{- end }}

{{- define "paths.uiIngressTlsSecretName" -}}
{{- default (printf "%s-ui-tls" (include "paths.fullname" .)) .Values.ui.nextjs.ingress.tlsSecretName }}
{{- end }}

{{- define "paths.deploymentDomain" -}}
{{- default (printf "paths.%s.%s" .Values.environment .Values.baseDomain) .Values.deploymentDomainOverride }}
{{- end }}

{{- define "paths.backendAdminHost" -}}
{{- default (printf "admin.%s" (include "paths.deploymentDomain" .)) .Values.backendAdminHostOverride }}
{{- end }}

{{- define "paths.backendApiHost" -}}
{{- default (printf "api.%s" (include "paths.deploymentDomain" .)) .Values.backendApiHostOverride }}
{{- end }}

{{- define "paths.uiDeploymentHost" -}}
{{- default (printf "*.%s" (include "paths.deploymentDomain" .)) .Values.uiDeploymentHostOverride }}
{{- end }}

# FIXME: The following are duplicated from the django chart. Create a library chart for them?
{{- define "paths.dbClusterRwServiceName" -}}
{{/* {{- printf "%s-rw" (include "paths.dbClusterName" .) }} */}}
{{- printf "db-cluster-rw" }}
{{- end }}
{{/* {{- define "paths.dbClusterName" -}} */}}
{{/* {{- default (include "paths.fullname" .) .Values.backend.django.db.cluster.name }} */}}
{{/* {{- end }} */}}
{{- define "paths.dbUrlScheme" -}}
{{- if .Values.backend.django.db.postgis }}postgis{{ else }}postgresql{{ end }}
{{- end }}
