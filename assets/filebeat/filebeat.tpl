{{range .configList}}
- type: log
  enabled: true
  paths:
      - {{ .HostDir }}/{{ .File }}
  cri.parse_flags: true
  multiline:
    pattern: '^(DEBUG|INFO|WARN|ERROR|\[|\(node|\d{4}/|\d+\.)'
    negate: true
    match: after
  scan_frequency: 10s
  fields_under_root: true
  {{if .Stdout}}
  {{end}}
  {{if eq .Format "json"}}
  json.keys_under_root: true
  {{end}}
  fields:
      {{range $key, $value := .CustomFields}}
      {{ $key }}: {{ $value }}
      {{end}}
      {{range $key, $value := .Tags}}
      {{ $key }}: {{ $value }}
      {{end}}
      {{range $key, $value := $.container}}
      {{ $key }}: {{ $value }}
      {{end}}
  {{range $key, $value := .CustomConfigs}}
  {{ $key }}: {{ $value }}
  {{end}}
  tail_files: false
  close_inactive: 2h
  close_eof: false
  close_removed: true
  clean_removed: true
  close_renamed: false

{{end}}
