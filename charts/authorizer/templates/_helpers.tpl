{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "authorizer.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "authorizer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
access-watcher app name
*/}}
{{- define "authorizer.watcher.name" -}}
{{- default "access-watcher" .Values.watcher.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
access-watcher common labels
*/}}
{{- define "authorizer.watcher.labels" -}}
{{ include "authorizer.watcher.selectorLabels" . }}
{{- end }}

{{/*
access-watcher selector labels
*/}}
{{- define "authorizer.watcher.selectorLabels" -}}
app.kubernetes.io/name: {{ include "authorizer.watcher.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
access-watcher fully qualified app name
*/}}
{{- define "authorizer.watcher.fullname" -}}
{{- if .Values.watcher.fullnameOverride }}
{{- .Values.watcher.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default (printf "%s-%s" .Release.Name "access-watcher") .Values.watcher.nameOverride }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "authorizer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "authorizer.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the CockroachDB hostname
*/}}
{{- define "authorizer.databaseHost" -}}
    {{- printf "%s" (include "call-nested" (list . "access-controller" "access-controller.databaseHost")) -}}
{{- end -}}

{{/*
Return the CockroachDB port
*/}}
{{- define "authorizer.databasePort" -}}
    {{- printf "%s" (include "call-nested" (list . "access-controller" "access-controller.databasePort")) -}}
{{- end -}}

{{/*
Return the CockroachDB database name
*/}}
{{- define "authorizer.databaseName" -}}
    {{- printf "%s" (include "call-nested" (list . "access-controller" "access-controller.databaseName")) -}}
{{- end -}}

{{/*
Return the CockroachDB username
*/}}
{{- define "authorizer.databaseUsername" -}}
    {{- printf "%s" (include "call-nested" (list . "access-controller" "access-controller.databaseUsername")) -}}
{{- end -}}

{{/*
Return the CockroachDB secret name
*/}}
{{- define "authorizer.databaseSecretName" -}}
    {{- printf "%s" (include "call-nested" (list . "access-controller" "access-controller.databaseSecretName")) -}}
{{- end -}}

{{- define "call-nested" }}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 | splitList "." }}
{{- $template := index . 2 }}
{{- $values := $dot.Values }}
{{- range $subchart }}
{{- $values = index $values . }}
{{- end }}
{{- include $template (dict "Chart" (dict "Name" (last $subchart)) "Values" $values "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end }}